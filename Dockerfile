FROM tomcat:9
ENV TZ Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV JAVA_OPTS="-Dspring.profiles.active=prod"
ENV FRS_ACTIVE="prod"

ENV FRS_DB_URL="jdbc:log4jdbc:mysql://pdteam-dev-db.cwbuq98fc0gd.ap-northeast-2.rds.amazonaws.com:3306/lord_system_fcs"
ENV FRS_DB_USERNAME="admin"
ENV FRS_DB_PASSWORD="cubox2021!"

ENV FRS_API_URL="https://dev-lordsystem-api.cubox-pd.com"
ENV FRS_API_KEY="DEVLORDS-C34D-D47C-50FF-4E2D87C9336B"

ENV FRS_GALLERY_IMAGE_YN="Y"
ENV FRS_HISTORY_IMAGE_GB="F"

ENV FRS_S3_bucketName="cu-pdteam-bucket"
ENV FRS_S3_accessKey="AKIA3P2NFMCUOPBDJ7P6"
ENV FRS_S3_secretKey="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"

RUN rm -rf /usr/local/tomcat/webapps/ROOT.war
COPY ./ROOT.war /usr/local/tomcat/webapps/ROOT.war
CMD ["catalina.sh","run"]