import os
from email.message import EmailMessage
import ssl
import smtplib

email_sender = 'dlizarbeb@gmail.com'
email_password = 'gnvrznzfbxnbnfsq'
email_receiver = 'da.lizarbebar@gmail.com'

subject= 'Jackmackerel'
body= """
The Jackmackerel track has finished, you can now
initiate another particles deploy, have a nice day Daniel!
🐟
"""
em=EmailMessage()
em['From']=email_sender
em['To']=email_receiver
em['Subject']= subject
em.set_content(body)

context = ssl.create_default_context()

with smtplib.SMTP_SSL('smtp.gmail.com', 465, context=context) as smtp:
  smtp.login(email_sender,email_password)
  smtp.sendmail(email_sender,email_receiver, em.as_string())
