@echo on
net use k: "\\fileserver2\util$\Aplicativos\Microsoft\Office's\Office 2016" /USER:rqr\giovani.paganini /persistent:no
k:
setup /configure "configuration.xml"
net use * /d
