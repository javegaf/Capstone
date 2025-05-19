-- ======================================
-- DDL modelo lógico final con tablas intermedias de estados
-- Tablas en mayúsculas, atributos en minúsculas
-- Optimizado para Oracle 11g+
-- ======================================

CREATE TABLE ROL_USUARIO (
    id_rol NUMBER PRIMARY KEY,
    nombre_rol VARCHAR2(50) UNIQUE NOT NULL
);

CREATE TABLE USUARIO (
    id_usuario NUMBER PRIMARY KEY,
    id_rol NUMBER DEFAULT 1 NOT NULL REFERENCES ROL_USUARIO(id_rol),
    correo VARCHAR2(150) UNIQUE NOT NULL,
    nombre_usuario VARCHAR2(100) NOT NULL,
    contrasena VARCHAR2(100) NOT NULL,
    fecha_registro DATE DEFAULT sysdate NOT NULL,
    sexo CHAR(1) CHECK (sexo IN ('m','f','o')) NOT NULL,
    fecha_nacimiento DATE NOT NULL
);

CREATE TABLE ESTADO_ACREDITACION (
    id_estado_acreditacion NUMBER PRIMARY KEY,
    nombre_estado VARCHAR2(50) UNIQUE NOT NULL,
    descripcion VARCHAR2(100)
);

CREATE TABLE ORGANIZADOR (
    id_organizador NUMBER PRIMARY KEY,
    id_usuario NUMBER UNIQUE REFERENCES USUARIO(id_usuario),
    nombre_organizacion VARCHAR2(150) NOT NULL,
    descripcion VARCHAR2(500),
    documento_acreditacion VARCHAR2(250),
    acreditado NUMBER(1) CHECK (acreditado IN (0,1)) DEFAULT 0
);

CREATE TABLE HISTORIAL_ESTADO_ACREDITACION (
    id_organizador NUMBER NOT NULL REFERENCES ORGANIZADOR(id_organizador),
    id_estado_acreditacion NUMBER NOT NULL REFERENCES ESTADO_ACREDITACION(id_estado_acreditacion),
    fecha_cambio DATE DEFAULT sysdate NOT NULL,
    PRIMARY KEY (id_organizador, id_estado_acreditacion)
);

CREATE TABLE CATEGORIA_EVENTO (
    id_categoria NUMBER PRIMARY KEY,
    nombre_categoria VARCHAR2(100) UNIQUE NOT NULL
);

CREATE TABLE ESTADO_EVENTO (
    id_estado_evento NUMBER PRIMARY KEY,
    nombre_estado VARCHAR2(50) UNIQUE NOT NULL,
    descripcion VARCHAR2(20)
);

CREATE TABLE EVENTO (
    id_evento NUMBER PRIMARY KEY,
    id_organizador NUMBER NOT NULL REFERENCES ORGANIZADOR(id_organizador),
    id_categoria NUMBER NOT NULL REFERENCES CATEGORIA_EVENTO(id_categoria),
    titulo VARCHAR2(150) NOT NULL,
    descripcion VARCHAR2(1000),
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    fecha_registro DATE DEFAULT sysdate NOT NULL,
    ubicacion VARCHAR2(250) NOT NULL,
    latitud NUMBER(9,6),
    longitud NUMBER(9,6),
    imagen VARCHAR2(250),
    capacidad NUMBER NOT NULL
);

CREATE TABLE HISTORIAL_ESTADO_EVENTO (
    id_evento NUMBER NOT NULL REFERENCES EVENTO(id_evento),
    id_estado_evento NUMBER NOT NULL REFERENCES ESTADO_EVENTO(id_estado_evento),
    fecha_cambio DATE DEFAULT sysdate NOT NULL,
    PRIMARY KEY (id_evento, id_estado_evento)
);

CREATE TABLE CALIFICACION_EVENTO (
    id_calificacion NUMBER PRIMARY KEY,
    id_usuario NUMBER NOT NULL REFERENCES USUARIO(id_usuario),
    id_evento NUMBER NOT NULL REFERENCES EVENTO(id_evento),
    puntuacion NUMBER(1) CHECK (puntuacion BETWEEN 1 AND 5),
    comentario VARCHAR2(1000),
    fecha DATE DEFAULT sysdate NOT NULL
);

CREATE TABLE ESTADO_DENUNCIA (
    id_estado_denuncia NUMBER PRIMARY KEY,
    nombre_estado VARCHAR2(50) UNIQUE NOT NULL,
    descripcion VARCHAR2(100)
);

CREATE TABLE DENUNCIA (
    id_denuncia NUMBER PRIMARY KEY,
    id_denunciante NUMBER NOT NULL REFERENCES USUARIO(id_usuario),
    id_denunciado NUMBER NOT NULL REFERENCES USUARIO(id_usuario),
    id_evento NUMBER NOT NULL REFERENCES EVENTO(id_evento),
    motivo VARCHAR2(500) NOT NULL,
    fecha_denuncia DATE DEFAULT sysdate NOT NULL,
    fecha_revision DATE
);

CREATE TABLE HISTORIAL_ESTADO_DENUNCIA (
    id_denuncia NUMBER NOT NULL REFERENCES DENUNCIA(id_denuncia),
    id_estado_denuncia NUMBER NOT NULL REFERENCES ESTADO_DENUNCIA(id_estado_denuncia),
    fecha_cambio DATE DEFAULT sysdate NOT NULL,
    PRIMARY KEY (id_denuncia, id_estado_denuncia)
);

CREATE TABLE ESTADO_NOTIFICACION (
    id_estado_notificacion NUMBER PRIMARY KEY,
    nombre_estado VARCHAR2(50) UNIQUE NOT NULL,
    descripcion VARCHAR2(100)
);

CREATE TABLE NOTIFICACION (
    id_notificacion NUMBER PRIMARY KEY,
    id_usuario NUMBER NOT NULL REFERENCES USUARIO(id_usuario),
    mensaje VARCHAR2(500) NOT NULL,
    fecha_envio DATE DEFAULT sysdate NOT NULL
);

CREATE TABLE HISTORIAL_ESTADO_NOTIFICACION (
    id_notificacion NUMBER NOT NULL REFERENCES NOTIFICACION(id_notificacion),
    id_estado_notificacion NUMBER NOT NULL REFERENCES ESTADO_NOTIFICACION(id_estado_notificacion),
    fecha_cambio DATE DEFAULT sysdate NOT NULL,
    PRIMARY KEY (id_notificacion, id_estado_notificacion)
);

CREATE TABLE SEGUIMIENTO_ORGANIZACION (
    id_seguimiento NUMBER PRIMARY KEY,
    id_usuario NUMBER NOT NULL REFERENCES USUARIO(id_usuario),
    id_organizador NUMBER NOT NULL REFERENCES ORGANIZADOR(id_organizador),
    fecha_seguimiento DATE DEFAULT sysdate NOT NULL
);