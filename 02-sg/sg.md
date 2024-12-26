- name: Roboshop SG and Rules
  security_groups:
  - DB:
    - mongodb
    - redis
    - mysql
    - rabbitmq
  - APP:
    - catalogue
    - user
    - cart
    - shipping
    - payment
  - WEB:
    - web
  - VPN:
    - vpn
      ingress_rule:
  - The naming convention i am following is opposite to this because i'm following source sg -> added to which
  - if we are adding vpn to mongodb , vpn->mongodb since it will be added to mongodb so i'm following vpn_mongodb
  - mongodb:
    - name: mongodb_vpn/vpn_mongodb
      purpose: mongodb should accept traffic on 22 from vpn
    - name: mongodb_catalogue=>catalogue_mongodb
      purpose: mongodb should accept traffic on 27017 from catalogue
    - name: mongodb_user=>user_mongodb
      purpose: mongodb should accept traffic on 27017 from user
  - redis:
    - name: redis_vpn=>vpn_redis
      purpose: redis should accept traffic on 22 from vpn
    - name: redis_user=>user_redis
      purpose: redis should accept traffic on 6379 from user
    - name: redis_cart=>cart_redis
      purpose: redis should accept traffic on 6379 from cart
  - mysql:
    - name: mysql_vpn=>vpn_mysql
      purpose: mysql should accept traffic on 22 from vpn
    - name: mysql_shipping=>shipping_mysql
      purpose: mysql should accept traffic on 3306 from shipping
  - rabbitmq:
    - name: rabbitmq_vpn=>vpn_rabbitmq
      purpose: rabbitmq should accept traffic on 22 from vpn
    - name: rabbitmq_payment=>payment_rabbitmq
      purpose: rabbitmq should accept traffic on 5672 from payment
  - catalogue:
    - name: catalogue_vpn=>vpn_catalogue
      purpose: catalogue should accept traffic on 22 from vpn
    - name: catalogue_web=>web_catalogue
      purpose: catalogue should accept traffic on 8080 from web
    - name: catalogue_cart=>cart_catalogue
      purpose: catalogue should accept traffic on 8080 from cart
  - user:
    - name: user_vpn=>vpn_user
      purpose: user should accept traffic on 22 from vpn
    - name: user_web=>web_user
      purpose: user should accept traffic on 8080 from web
    - name: user_payment=>payment_user
      purpose: user should accept traffic on 8080 from payment
  - cart:
    - name: cart_vpn=>vpn_cart
      purpose: cart should accept traffic on 22 from vpn
    - name: cart_web=>web_cart
      purpose: cart should accept traffic on 8080 from web
    - name: cart_shipping=>shipping_cart
      purpose: cart should accept traffic on 8080 from shipping
    - name: cart_payment=>payment_cart
      purpose: cart should accept traffic on 8080 from payment
  - shipping:
    - name: shipping_vpn=>vpn_shipping
      purpose: shipping should accept traffic on 22 from vpn
    - name: shipping_web=>web_shipping
      purpose: shipping should accept traffic on 8080 from web
  - payment:
    - name: payment_vpn=>vpn_payment
      purpose: payment should accept traffic on 22 from vpn
    - name: payment_web=>web_payment
      purpose: payment should accept traffic on 8080 from web
  - web:
    - name: web_vpn=>vpn_web
      purpose: web should accept traffic on 22 from vpn
    - name: web_internet=>web_internet
      purpose: web should accept traffic on 80 from internet
