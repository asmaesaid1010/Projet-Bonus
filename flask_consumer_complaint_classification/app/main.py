import jsonpickle
from flask import Flask, request, render_template, Response

from consumer_complaint_classification_exam.app.services.fetch_prediction import process_text

app = Flask(__name__)


@app.route('/complaintFromFlutter', methods=['GET', 'POST'])
def complaintFromFlutter():
    if request.method == 'POST':
        # complaint = request.form["complaint"]
        print(request.is_json)
        content = request.get_json()
        print(content)
        complaint = content['complaint']
        print("--------", complaint)
        prediction, confidence = process_text(complaint)

        response = {'prediction': str(prediction), 'confidence': str(confidence)}

        # encode response using jsonpickle
        response_pickled = jsonpickle.encode(response)
        print("****************************")
        print(response_pickled)
        print("****************************")
        print("ok")
        return Response(response=response_pickled)


@app.route('/')
def my_form():
    return render_template('index.html')


@app.route('/', methods=['POST'])
def my_form_post():
    complaint = request.form['complaint']
    prediction, confidence = process_text(complaint)
    return render_template('model_predictions.html', result=prediction, confidence=confidence)


if __name__ == '__main__':
    app.run(host="0.0.0.0", debug=True, port=8000)
