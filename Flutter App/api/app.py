import os
from flask import Flask, request, jsonify
import tensorflow as tf
import joblib
import numpy as np

app = Flask(__name__)

UPLOAD_FOLDER = 'uploads'
os.makedirs(UPLOAD_FOLDER, exist_ok=True) 
app.config['upload_folder'] = UPLOAD_FOLDER

# Load the CNN model saved in Keras format
modelBack = tf.keras.models.load_model('modelBack.keras')
modelFrontOn = tf.keras.models.load_model('modelFrontOn.keras')
modelFrontOff = tf.keras.models.load_model('modelFrontOff.keras')
modelPrice = joblib.load('model.pkl')

@app.route('/predictBack', methods=['POST'])
def predictBack():
    try:
        # Check if the file is in the request
        if 'file' not in request.files:
            return jsonify({'error': 'No file provided'}), 400

        # Get the file from the request
        file = request.files['file']
        file_path = os.path.join(app.config['upload_folder'], file.filename)
        file.save(file_path)

        # Preprocess the image
        image = tf.keras.preprocessing.image.load_img(file_path, target_size=(256, 256))
        image_array = tf.keras.preprocessing.image.img_to_array(image) / 255.0
        image_array = np.expand_dims(image_array, axis=0)

        # Predicting using the model
        prediction = modelBack.predict(image_array)
        predicted_class = np.argmax(prediction, axis=-1)[0]
        confidence = np.max(prediction)

        os.remove(file_path)

        # Returning the prediction result as JSON
        return jsonify({
            'predicted_class': int(predicted_class),
            'confidence': float(confidence)
        })

    except Exception as e:
        # Handling errors
        return jsonify({'error': str(e)}), 500

@app.route('/predictFrontOn', methods=['POST'])
def predictFrontOn():
    try:
        if 'file' not in request.files:
            return jsonify({'error': 'No file provided'}), 400

        file = request.files['file']
        file_path = os.path.join(app.config['upload_folder'], file.filename)
        file.save(file_path)

        image = tf.keras.preprocessing.image.load_img(file_path, target_size=(256, 256))
        image_array = tf.keras.preprocessing.image.img_to_array(image) / 255.0
        image_array = np.expand_dims(image_array, axis=0)

        prediction = modelFrontOn.predict(image_array)
        predicted_class = np.argmax(prediction, axis=-1)[0]
        confidence = np.max(prediction)

        os.remove(file_path)

        return jsonify({
            'predicted_class': int(predicted_class),
            'confidence': float(confidence)
        })

    except Exception as e:
        return jsonify({'error': str(e)}), 500
    

@app.route('/predictFrontOff', methods=['POST'])
def predictFrontOff():
    try:
        if 'file' not in request.files:
            return jsonify({'error': 'No file provided'}), 400

        file = request.files['file']
        file_path = os.path.join(app.config['upload_folder'], file.filename)
        file.save(file_path)

        image = tf.keras.preprocessing.image.load_img(file_path, target_size=(256, 256))
        image_array = tf.keras.preprocessing.image.img_to_array(image) / 255.0
        image_array = np.expand_dims(image_array, axis=0)

        prediction = modelFrontOff.predict(image_array)
        predicted_class = np.argmax(prediction, axis=-1)[0]
        confidence = np.max(prediction)

        os.remove(file_path)

        return jsonify({
            'predicted_class': int(predicted_class),
            'confidence': float(confidence)
        })

    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/predictPrice', methods=['POST'])
def predictPrice():
    try:
        if not request.is_json:
            return jsonify({'error': 'Request must be in JSON format'}), 400

        data = request.get_json()

        expected_features = [
            'Phone Company', 'RAM', 'Storage', 'Processor', 'Battery Capacity', 
            'Operating System', 'External Condition', '5g Support', 'PTA Approved',
            'Year of Release', 'Original Price'
        ]

        if not all(feature in data for feature in expected_features):
            return jsonify({'error': f'Missing one or more features: {expected_features}'}), 400

        input_data = [data[feature] for feature in expected_features]
        input_array = np.array(input_data).reshape(1, -1)

        predicted_price = modelPrice.predict(input_array)[0]

        predicted_price = float(predicted_price)

        return jsonify({'predicted_price': round(predicted_price, 2)})

    except Exception as e:
        print(f"Error occurred: {e}")
        return jsonify({'error': str(e)}), 500

#Running the flask app
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
