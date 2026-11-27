const express = require('express');
const router = express.Router();

// Importar todas las rutas
const authRoutes = require('../modules/auth/auth.routes');
const usuariosRoutes = require('../modules/usuarios/usuarios.routes');
const usuariosEmpresasRoutes = require('../modules/usuario_empresas/usuario_empresas.routes')
const rolesRoutes = require('../modules/roles/roles.routes');
const permisosRoutes = require('../modules/permisos/permisos.routes');
const rolPermisosRoutes = require('../modules/rol_permisos/rol_permisos.routes');
const empresasRoutes = require('../modules/empresas/empresas.routes');
const auditoriaRoutes = require('../modules/auditoria/auditoria.routes');
const catalogoAccionesMovimientoRoutes = require('../modules/catalogos/acciones_movimiento/acciones_movimiento.routes');

router.use('/auth', authRoutes);
router.use('/usuarios', usuariosRoutes);
router.use('/usuarios-empresas', usuariosEmpresasRoutes)
router.use('/roles', rolesRoutes);
router.use('/permisos', permisosRoutes);
router.use('/rol-permisos', rolPermisosRoutes);
router.use('/empresas', empresasRoutes);
router.use('/upload', require('../modules/upload/upload.routes'));

module.exports = router;