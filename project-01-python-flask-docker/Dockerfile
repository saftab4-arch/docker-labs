

#from python since this is a pythin app
FROM python:3.12

#create work directory where this code stays, every command after this runs inside app folder
WORKDIR /app

#Copy requirements.txt from host machine to /app inside image
COPY requirements.txt .

#install required dependencies
RUN pip install -r requirements.txt

#copy the application files
COPY . .


#expose port, tell application to listen on port
EXPOSE 5000

# to run this image
CMD ["python", "app.py"]



#FROM python:3.12
#        ↓
#Create Linux + Python Image
 #       ↓
#WORKDIR /app
 #       ↓
#Move into /app
 #       ↓
#COPY requirements.txt .
 #       ↓
#Copy dependency list
  #      ↓
#RUN pip install -r requirements.txt
   #     ↓
#Install Flask
    #    ↓
#COPY . .
     #   ↓
#Copy application files
      #  ↓
#EXPOSE 5000
      #  ↓
#Application uses port 5000
       # ↓
#CMD ["python","app.py"]
       # ↓
#Start Flask app 
