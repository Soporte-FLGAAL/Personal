CREATE DATABASE IF NOT EXISTS Personal;

USE Personal;

-- =========================================================
-- ROLES Y PERMISOS
-- =========================================================
CREATE TABLE IF NOT EXISTS Roles(
    Rol_id INT NOT NULL AUTO_INCREMENT,
    Rol_nombre VARCHAR(20) NOT NULL UNIQUE,
    PRIMARY KEY(Rol_id)
);

CREATE TABLE IF NOT EXISTS Permisos(
    PerM_id INT NOT NULL AUTO_INCREMENT,
    PerM_nombre VARCHAR(50) NOT NULL UNIQUE,
    PRIMARY KEY(PerM_id)
);

CREATE TABLE IF NOT EXISTS Rol_Permisos(
    RP_rol INT NOT NULL,
    RP_permiso INT NOT NULL,
    PRIMARY KEY (RP_rol, RP_permiso),
    FOREIGN KEY (RP_rol) REFERENCES Roles(Rol_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (RP_permiso) REFERENCES Permisos(PerM_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Usuario(
    Usu_id INT NOT NULL AUTO_INCREMENT,
    Usu_nombres VARCHAR(50) NOT NULL,
    Usu_ap_paterno VARCHAR(25) NOT NULL,
    Usu_ap_materno VARCHAR(25),
    Usu_telefono VARCHAR(13),
    Usu_correo VARCHAR(255) NOT NULL UNIQUE,
    Usu_password VARCHAR(255) NOT NULL,
    Usu_status ENUM ('ACTIVO', 'INACTIVO') NOT NULL DEFAULT 'ACTIVO',
    Usu_fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Usu_ultimo_acceso DATETIME NULL,
    PRIMARY KEY (Usu_id)
);

-- =========================================================
-- TOKENS
-- =========================================================

CREATE TABLE IF NOT EXISTS RefreshTokens (
  RT_id INT NOT NULL AUTO_INCREMENT,
  RT_usuario INT NOT NULL,
  RT_token VARCHAR(500) NOT NULL,
  RT_expiracion DATETIME NOT NULL,
  RT_creado_en DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (RT_id),
  UNIQUE KEY uq_token (RT_token),
  FOREIGN KEY (RT_usuario) REFERENCES Usuario(Usu_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- =========================================================
-- AUDITORIA
-- =========================================================
CREATE TABLE IF NOT EXISTS Movimientos(
    Mov_id INT NOT NULL AUTO_INCREMENT,
    Mov_tabla_afectada VARCHAR(30) NOT NULL,
    Mov_registro_afectado VARCHAR(25) NOT NULL,
    Mov_accion INT NOT NULL,
    Mov_detalles JSON NOT NULL,
    Mov_fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Mov_usu_id INT,
    PRIMARY KEY (Mov_id),
    FOREIGN KEY (Mov_accion) REFERENCES Acciones_movimiento(AcM_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (Mov_usu_id) REFERENCES Usuario(Usu_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Acciones_movimiento(
    AcM_id INT NOT NULL AUTO_INCREMENT,
    AcM_nombre VARCHAR(20) NOT NULL UNIQUE,
    PRIMARY KEY (AcM_id)
);

-- =========================================================
-- CATALOGOS DEL DOMINIO
-- =========================================================
CREATE TABLE IF NOT EXISTS Tipo_asistencia(
    TpA_id INT NOT NULL AUTO_INCREMENT
    TpA_nombre VARCHAR(30) NOT NULL,
    PRIMARY KEY (TpA_id)
);

CREATE TABLE IF NOT EXISTS Tipo_inasistencia(
    TpI_id INT NOT NULL AUTO_INCREMENT,
    TpI_nombre VARCHAR(30) NOT NULL,
    PRIMARY KEY (TpI_id)
);

CREATE TABLE IF NOT EXISTS Tipo_checada(
    TpC_id INT NOT NULL AUTO_INCREMENT,
    TpC_nombre VARCHAR(30) NOT NULL,
    PRIMARY KEY (TpC_id)
);

CREATE TABLE IF NOT EXISTS Tipo_justificante(
    TpJ_id INT NOT NULL AUTO_INCREMENT,
    TpJ_nombre VARCHAR(30) NOT NULL,
    PRIMARY KEY (TpJ_id)
);

CREATE TABLE IF NOT EXISTS Tipo_epp(
    TpE_id INT NOT NULL AUTO_INCREMENT,
    TpE_nombre VARCHAR(30) NOT NULL,
    PRIMARY KEY (TpE_id)
);

CREATE TABLE IF NOT EXISTS Tipo_sangre(
    TpS_id INT NOT NULL AUTO_INCREMENT,
    TpS_nombre VARCHAR(10) NOT NULL,
    PRIMARY KEY (TpS_id)
);

CREATE TABLE IF NOT EXISTS Alergias(
    TpAl_id INT NOT NULL AUTO_INCREMENT,
    TpAl_nombre VARCHAR(30) NOT NULL,
    PRIMARY KEY (TpAl_id)
);

CREATE TABLE IF NOT EXISTS Enfermedades(
    TpEnf_id INT NOT NULL AUTO_INCREMENT,
    TpEnf_nombre VARCHAR(50) NOT NULL,
    PRIMARY KEY(TpEnf)
);

CREATE TABLE IF NOT EXISTS Tolerancia(
    Tol_id INT NOT NULL AUTO_INCREMENT,
    Tol_minutos VARCHAR(20) NOT NULL,
    PRIMARY KEY (Tol_id)
);

CREATE TABLE IF NOT EXISTS Empresas(
    Emp_id INT NOT NULL AUTO_INCREMENT,
    Emp_nombre VARCHAR(100) NOT NULL,
    Emp_nombre_corto VARCHAR(20),
    Emp_direccion VARCHAR(150),
    Emp_rfc VARCHAR(13) NOT NULL UNIQUE,
    PRIMARY KEY (Emp_id)
);

CREATE TABLE IF NOT EXISTS Bases(
    Base_id INT NOT NULL AUTO_INCREMENT,
    Base_nombre VARCHAR(30) NOT NULL,
    PRIMARY KEY (Base_id)
);
-- =========================================================
-- Horarios
-- Un horario puede tener multiples clausulas y distintos permisos especiales
-- =========================================================
CREATE TABLE IF NOT EXISTS Horarios(
    Hor_id INT NOT NULL AUTO_INCREMENT,
    Hor_nombre VARCHAR(30) NOT NULL,
    Hor_tolerancia INT,
    PRIMARY KEY (Hor_id),
    FOREIGN KEY (Hor_tolerancia) REFERENCES Tolerancia(Tol_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Detalle_horarios(
    DH_id INT NOT NULL AUTO_INCREMENT,
    DH_horario INT,
    DH_dia_inicio VARCHAR(10) NOT NULL,
    DH_dia_fin VARCHAR(10) NOT NULL,
    DH_entrada TIME NOT NULL,
    DH_salida TIME NOT NULL,
    DH_entrada_comida TIME,
    DH_salida_comida TIME,
    PRIMARY KEY(DH_id),
    FOREIGN KEY (DH_horario) REFERENCES Horarios(Hor_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);
-- =========================================================
-- RELACION USUARIO - EMPRESA - ROL
-- Un usuario puede tener distintos roles en distintas empresas.
-- =========================================================
CREATE TABLE IF NOT EXISTS Usuario_Empresas(
    UE_usuario INT NOT NULL,
    UE_empresa INT NOT NULL,
    UE_rol INT NOT NULL,
    PRIMARY KEY (UE_usuario, UE_empresa),
    FOREIGN KEY (UE_usuario) REFERENCES Usuario(Usu_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (UE_empresa) REFERENCES Empresas(Emp_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (UE_rol) REFERENCES Roles(Rol_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- =========================================================
-- RELACION EMPRESA - Base
-- Una empresa puede tener multiples bases.
-- =========================================================
CREATE TABLE IF NOT EXISTS Empresa_Base(
    EB_id INT NOT NULL AUTO_INCREMENT,
    EB_empresa INT NOT NULL,
    EB_base INT NOT NULL,
    PRIMARY KEY (EB_id),
    FOREIGN KEY (EB_empresa) REFERENCES Empresas(Emp_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (EB_base) REFERENCES Bases(Base_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- =========================================================
-- Personal de las empresas
-- =========================================================
CREATE TABLE IF NOT EXISTS Personal(
    Pers_id INT NOT NULL AUTO_INCREMENT,
    Pers_nombres VARCHAR(50) NOT NULL,
    Pers_ap_paterno VARCHAR(25) NOT NULL,
    Pers_ap_materno VARCHAR(25) NOT NULL,
    Pers_telefono VARCHAR(13),
    Pers_correo VARCHAR(50),
    Pers_zam_id INT,
    Pers_reloj_id VARCHAR(10),
    Pers_empresa_base INT,
    Pers_status ENUM('ALTA', 'BAJA'),
    Pers_fecha_alta DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Pers_fecha_contratacion DATE,
    Pers_horario INT,
    PRIMARY KEY (Pers_id),
    FOREIGN KEY (Pers_empresa_base) REFERENCES Empresa_Base(EB_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (Pers_horario) REFERENCES Horarios(Hor_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- =========================================================
-- Control de asistencia
-- =========================================================
CREATE TABLE IF NOT EXISTS Asistencia(
    Asis_id INT NOT NULL AUTO_INCREMENT,
    Asis_pers_id INT,
    Asis_fecha DATE NOT NULL,
    Asis_hora TIME,
    Asis_hora_reloj TIME,
    Asis_tipo_asistencia INT,
    Asis_tipo_inasistencia INT,
    Asis_empresa_base INT,
    PRIMARY KEY (Asis_id),
    FOREIGN KEY (Asis_pers_id) REFERENCES Personal(Pers_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (Asis_tipo_asistencia) REFERENCES Tipo_asistencia(TpA_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (Asis_tipo_inasistencia) REFERENCES Tipo_inasistencia(TpI_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (Asis_empresa_base) REFERENCES Empresa_Base(EB_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE 
);

CREATE TABLE IF NOT EXISTS Vacaciones(
    Vac_id INT NOT NULL AUTO_INCREMENT,
    Vac_pers_id INT,
    Vac_fecha_inicio DATE NOT NULL,
    Vac_fecha_fin DATE NOT NULL,
    Vac_url VARCHAR(255) NOT NULL,
    PRIMARY KEY (Vac_id),
    FOREIGN KEY (Vac_pers_id) REFERENCES Personal(Pers_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE 
);

CREATE TABLE IF NOT EXISTS Incapacidades(
    Inc_id INT NOT NULL AUTO_INCREMENT,
    Inc_pers_id INT,
    Inc_fecha_inicio DATE NOT NULL,
    Inc_fecha_fin DATE NOT NULL,
    Inc_url VARCHAR(255) NOT NULL,
    PRIMARY KEY (Inc_id),
    FOREIGN KEY (Inc_pers_id) REFERENCES Personal(Pers_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE 
);

CREATE TABLE IF NOT EXISTS Justificantes(
    Just_id INT NOT NULL AUTO_INCREMENT,
    Just_asis_id INT,
    Just_tipo INT,
    Just_url VARCHAR(255) NOT NULL,
    PRIMARY KEY (Inc_id),
    FOREIGN KEY (Just_asis_id) REFERENCES Asistencia(Asis_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (Just_tipo) REFERENCES Tipo_justificante(TpJ_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE 
);


-- =========================================================
-- Control de EPP
-- =========================================================
CREATE TABLE IF NOT EXISTS Entrega_EPP(
    EEPP_id INT NOT NULL AUTO_INCREMENT,
    EEPP_pers_id INT,
    EEPP_usuario_autorizo INT,
    EEPP_usuario_entrego INT,
    EEPP_tipo_epp INT,
    EEPP_url VARCHAR(255) NOT NULL,
    PRIMARY KEY (EEPP_id),
    FOREIGN KEY (EEPP_pers_id) REFERENCES Personal(Pers_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (EEPP_usuario_autorizo) REFERENCES Usuario(Usu_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (EEPP_usuario_entrego) REFERENCES Usuario(Usu_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (EEPP_tipo_epp) REFERENCES Tipo_epp(TpE_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE  
);

-- =========================================================
-- Control de salud
-- =========================================================
CREATE TABLE IF NOT EXISTS Salud(
    Sal_id INT NOT NULL AUTO_INCREMENT,
    Sal_pers_id INT,
    Sal_tipo_sangre INT,
    PRIMARY KEY(Sal_id)
    FOREIGN KEY (Sal_pers_id) REFERENCES Personal(Pers_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (Sal_tipo_sangre) REFERENCES Tipo_sangre(TpS_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE  
);

CREATE TABLE IF NOT EXISTS Detalle_salud_alergia(
    DS_sal_id INT,
    DS_tipo_alergia INT,
    DS_URL VARCHAR(255),
    PRIMARY KEY(DS_sal_id, DS_tipo_alergia)
    FOREIGN KEY (DS_sal_id) REFERENCES Salud(Sal_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (DS_tipo_alergia) REFERENCES Alergias(TpAl_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE  
);

CREATE TABLE IF NOT EXISTS Detalle_salud_enfermedades(
    DS_sal_id INT,
    DS_tipo_enfermedad INT,
    DS_URL VARCHAR(255),
    PRIMARY KEY(DS_sal_id, DS_tipo_alergia)
    FOREIGN KEY (DS_sal_id) REFERENCES Salud(Sal_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (DS_tipo_enfermedad) REFERENCES Enfermedades(TpEnf_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE  
);

CREATE TABLE IF NOT EXISTS Archivos (
  Arc_id INT NOT NULL AUTO_INCREMENT,
  Arc_uuid CHAR(36) NOT NULL UNIQUE,
  Arc_nombre_original VARCHAR(255) NOT NULL,
  Arc_ruta VARCHAR(500) NOT NULL,          -- ruta relativa: uploads/{tipo}/{uuid}.ext
  Arc_mime VARCHAR(100) NOT NULL,
  Arc_tamano INT NOT NULL,                 -- bytes
  Arc_tipo VARCHAR(30) NOT NULL,           -- factura | poliza | tarjeta | sict | ...
  Arc_empresa INT NOT NULL,
  Arc_subido_por INT NOT NULL,
  Arc_fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (Arc_id),
  FOREIGN KEY (Arc_empresa) REFERENCES Empresas(Emp_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (Arc_subido_por) REFERENCES Usuario(Usu_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  INDEX idx_arc_empresa (Arc_empresa),
  INDEX idx_arc_uuid (Arc_uuid)
);

