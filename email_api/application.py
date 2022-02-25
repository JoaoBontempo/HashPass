from lib2to3.pgen2 import token
import os
from flask import Flask, abort,request, send_file
from flask_cors import cross_origin
import json

import jwt
from mail import sendMail, sendMailDataExport

api=Flask(__name__)
api.config['JSONIFY_PRETTYPRINT_REGULAR'] = False
db=None

@api.route('/token', methods=["POST"])
def enviarToken():
    try:
        mail = json.loads(request.data)
        return sendMail(mail['destinatario'], mail['token'])
    except Exception as e:
        return str(e)

@api.route('/export', methods=["POST"])
def enviarArquivoJSON():
    try:
        key = request.args.get('key')
        print(key)
        preToken = request.args.get('token')
        print(preToken)
        token = jwt.decode(preToken, key, algorithms=["HS256"])
        senhas = json.loads(request.data)
        print(token)
        print(senhas);      
        exp = token['exp']
        iat = token['iat']

        print('exp-iat : ' + str(exp-iat))
        
        if (exp-iat != 60):
            abort(403)
        if (token['sub'] != 'data export'):
            abort(403)
        if (token['iss'] != 'HashPass'):
            abort(403)
        if (token['type'] != 'Dart JWT'):
            abort(403)
        if (token['alg'] != 'HS256'):
            abort(403)
        
        payload = token['pld']

        json_object = json.dumps(senhas, indent = 4)
  
        with open("data.json", "w") as outfile:
            outfile.write(json_object)
        


        response = sendMailDataExport(payload['email'], payload['chave'], payload['dispositivo'], payload['SO'])
        os.remove('data.json')
        if response == True:
            return 'Dados exportados com sucesso!'
        else:
            return response
    except Exception as e:
        return str(e)

@api.route('/logo')
def get_image():
    return send_file("./HTML/logo-light.png", mimetype='image/gif')

if __name__=='__main__':
    api.run(debug=True)