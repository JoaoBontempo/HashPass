from datetime import datetime
from email import encoders
from email.mime.base import MIMEBase
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

ADDRESS = 'hashpass.software@gmail.com'
PASSWORD = '@hashpass_083923022022!'
HOST = 'smtp.gmail.com'
PORT = 587
ASSUNTO = "Confirmação de identidade - HashPass"

def sendMailDataExport(destinatario, chave, dispositivo, SO):
    try:
        server = smtplib.SMTP(HOST, PORT)
        server.ehlo()
        server.starttls()
        server.login(ADDRESS, PASSWORD)

        message = MIMEMultipart()
        message['From'] = ADDRESS
        message['To'] = destinatario
        message['Subject'] = "Exportação de dados - HashPass"
        message.attach(MIMEText(buildHTMLMNessageDataExport(chave, dispositivo, SO), 'html'))

        with open('data.json', 'rb') as att:
            fileData = MIMEBase('application', 'octet-stream')
            fileData.set_payload(att.read())
            encoders.encode_base64(fileData)
            fileData.add_header('Content-Disposition', 'attachment; filename=dados.json')

        message.attach(fileData)

        server.sendmail(message['From'], message['To'], message.as_string())
        server.quit()
        return True
    except Exception as e:
        return str(e)

def sendMail(destinatario, token):
    try:
        server = smtplib.SMTP(HOST, PORT)
        server.ehlo()
        server.starttls()
        server.login(ADDRESS, PASSWORD)

        message = MIMEMultipart()
        message['From'] = ADDRESS
        message['To'] = destinatario
        message['Subject'] = ASSUNTO
        message.attach(MIMEText(buildHTMLMNessage(token), 'html'))

        server.sendmail(message['From'], message['To'], message.as_string())
        server.quit()
        return "Email enviado com sucesso!"
    except Exception as e:
        return str(e)

def buildHTMLMNessage(token):
    with open("./HTML/sendtoken.html", "r", encoding='utf-8') as file:
        message = file.read()
    message = message.replace("@TOKEN", token)
    return message

def buildHTMLMNessageDataExport(chave, dispositivo, SO):
    with open("./HTML/dataexport.html", "r", encoding='utf-8') as file:
        message = file.read()
    message = message.replace("@CHAVE", chave)
    message = message.replace("@DEVICE", dispositivo)
    message = message.replace("@SO", SO)

    time = datetime.now()

    data = f'{formatarNumero(time.day)}/{formatarNumero(time.month)}/{time.year}'
    horario = f'{formatarNumero(time.hour)}:{formatarNumero(time.minute)}'
    message = message.replace("@DATE", data)
    message = message.replace("@TIME", horario)
    return message

def formatarNumero(num):
    if (num <= 9):
        return f'0{num}'
    else: return num