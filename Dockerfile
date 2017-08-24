FROM centos:latest
MAINTAINER ajoergensen

ENV LANG='en_US.UTF-8' LANGUAGE='en_US.UTF-8' TERM='xterm' TZ='Europe/Copenhagen'

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/ajoergensen/baseimage-centos.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0.0-rc1"


COPY root /

RUN \
	yum install epel-release yum-utils -y && \
	yum install -y https://centos7.iuscommunity.org/ius-release.rpm && \
	yum install -y http://mirror.ghettoforge.org/distributions/gf/gf-release-latest.gf.el7.noarch.rpm && \
	yum update -y && \
	yum install -y rsyslog bash psmisc file which bash-completion bash-completion-extras curl wget ssmtp && \
	wget -O /tmp/s6-overlay-amd64.tar.gz `curl -s https://api.github.com/repos/just-containers/s6-overlay/releases/latest | grep 'browser_' | cut -d\" -f4 | grep "s6-overlay-amd64.tar.gz$"` && \
	tar xvzf /tmp/s6-overlay-amd64.tar.gz -C / --exclude="./bin" --exclude="./sbin" && \
	#tar xvzf /tmp/s6-overlay-amd64.tar.gz -C /usr ./bin ./sbin && \
	tar xvzf /tmp/s6-overlay-amd64.tar.gz -C /usr ./bin ./libexec && \

	sh -c 'echo clean_requirements_on_remove=1 >> /etc/yum.conf' && \

	groupadd -g 911 app && \
	useradd -u 911 -g 911 -s /bin/false -m app && \
	usermod -G users app && \
	mkdir -p /app /config /defaults && \

	rm /tmp/* /etc/rsyslog.d/listen.conf /etc/rsyslog.conf.* && \
	yum clean all && \
	chmod -v +x /etc/cont-init.d/* /etc/services.d/*/run


ENTRYPOINT ["/init"]
CMD []
