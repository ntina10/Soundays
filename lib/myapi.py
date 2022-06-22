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
def hello_world():
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
    print(emotion)
    json_file['result'] = emotion

    return jsonify(json_file)

@app.route('/temp', methods = ['POST'])
def mytemp():
    json_file = {}
    json_file['query'] = 'Hello World!'

    print("This is an api call")
    print("Request", request.files)
    imagefile = request.files["image"]

    print("imagefile", imagefile)

    filename = "sth.jpg"
    imagefile.save("images/" + filename)
    test_image = "./images/" + filename

    print("save done")

    image_prediction = detector.detect_image(test_image)

    emotion = (image_prediction.emotions()).to_dict()
    print(emotion)
    print(emotion['anger'][0])
    if(math. isnan(emotion['anger'][0])):
        emotion = {}
        emotion['ans'] = 'No Face Detected!'

    json_file['result'] = emotion

    return jsonify(json_file)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3000)