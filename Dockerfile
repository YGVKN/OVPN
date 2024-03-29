FROM alpine

LABEL MAINTAINER="YGVKN/ZHUZHA <denisyagovkin@mail.ru>"
WORKDIR /etc/openvpn

RUN apk add --update vim tzdata nftables iptables bash bash-completion easy-rsa openvpn openvpn-auth-pam openvpn-auth-ldap google-authenticator libqrencode && \
     ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime && \
     ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && \
     rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

# Needed by scripts
ENV OPENVPN=/etc/openvpn
ENV EASYRSA=/usr/share/easy-rsa \
    EASYRSA_CRL_DAYS=3650 \
    EASYRSA_PKI=$OPENVPN/pki

VOLUME ["/etc/openvpn"]

# Internally uses port 1194/udp, remap using `docker run -p 443:1194/tcp`
EXPOSE 1111/udp

CMD ["ovpn_run"]

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

# Add support for OTP authentication using a PAM module
ADD ./otp/openvpn /etc/pam.d/
