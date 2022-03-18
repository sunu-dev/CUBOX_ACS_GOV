FROM tomcat:9
ENV TZ Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV JAVA_OPTS="-Dspring.profiles.active=prod"
ENV FRS_ACTIVE="prod"
ENV FRS_DB_URL="jdbc:log4jdbc:mysql://pdteam-dev-db.cvl9xeh1bwxz.ap-northeast-2.rds.amazonaws.com:3306/lord_system_frs"
ENV FRS_DB_USERNAME="admin"
ENV FRS_DB_PASSWORD="cubox2022!"

ENV FRS_API_URL="https://dev-lordsystem-api.cubox-pd.com"
ENV FRS_API_KEY="DEVLORDS-C34D-D47C-50FF-4E2D87C9336B"

ENV FRS_GALLERY_IMAGE_GB="S3"

ENV FRS_VERIFICATION_YN="Y"
ENV FRS_VERIFICATION_LOG_GB="S3"

ENV FRS_IDENTIFICATION_YN="Y"
ENV FRS_IDENTIFICATION_LOG_GB="S3"

ENV FRS_S3_bucketName="cu-pdteam-bucket"
ENV FRS_S3_accessKey="AKIA3P2NFMCUOPBDJ7P6"
ENV FRS_S3_secretKey="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"

RUN rm -rf /usr/local/tomcat/webapps/ROOT.war
COPY ./ROOT.war /usr/local/tomcat/webapps/ROOT.war
CMD ["catalina.sh","run"]


