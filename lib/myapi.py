import math
from flask import Flask, jsonify, request
import werkzeug.utils
from feat.detector import Detector

app = Flask(__name__)

face_model = "retinaface"
landmark_model = "mobilenet"
au_model = "rf"
emotion_model = "resmasknet"
detector = Detector(face_model = face_model, landmark_model = landmark_model, au_model = au_model, emotion_model = emotion_model)


@app.route('/')
def hello():
    return "Helloooo!"


@app.route('/emotion', methods = ['POST'])
def get_emotion():
    json_file = {}
    json_file['query'] = 'Hello World!'

    print("This is an api call")
    print("Request", request)
    imagefile = request.files["image"]

    print("imagefile image", imagefile)

    filename = werkzeug.utils.secure_filename(imagefile.filename)
    print("\nReceived image File name : " + imagefile.filename)
    imagefile.save("images/" + filename)
    test_image = "./images/" + filename

    image_prediction = detector.detect_image(test_image)

    emotion = (image_prediction.emotions()).to_dict()

    if(math. isnan(emotion['anger'][0])):
        emotion = {}
        emotion['ans'] = 'No Face Detected!'

    json_file['result'] = emotion
    json_file['file'] = filename

    print(json_file)

    return jsonify(json_file)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3000)