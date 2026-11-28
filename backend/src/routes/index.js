const express = require('express');
const router = express.Router();

router.use('/auth', require('../modules/auth/auth.routes'));
router.use('/roles', require('../modules/roles/roles.routes'));
router.use('/permisos', require('../modules/permisos/permisos.routes'));
router.use('/rol-permisos', require('../modules/rol_permisos/rol_permisos.routes'));
router.use('/empresas', require('../modules/empresas/empresas.routes'));
router.use('/bases', require('../modules/bases/bases.routes'));
router.use('/empresa-base', require('../modules/empresa_base/empresa_base.routes'));
router.use('/usuario-empresas', require('../modules/usuario_empresas/usuario_empresas.routes'));
router.use('/personal', require('../modules/personal/personal.routes'));
router.use('/horarios', require('../modules/horarios/horarios.routes'));
router.use('/detalle-horarios', require('../modules/detalle_horarios/detalle_horarios.routes'));
router.use('/asistencia', require('../modules/asistencia/asistencia.routes'));
router.use('/vacaciones', require('../modules/vacaciones/vacaciones.routes'));
router.use('/incapacidades', require('../modules/incapacidades/incapacidades.routes'));
router.use('/justificantes', require('../modules/justificantes/justificantes.routes'));
router.use('/entrega-epp', require('../modules/entrega_epp/entrega_epp.routes'));
router.use('/salud', require('../modules/salud/salud.routes'));
router.use('/detalle-salud-alergia', require('../modules/detalle_salud_alergia/detalle_salud_alergia.routes'));
router.use('/detalle-salud-enfermedades', require('../modules/detalle_salud_enfermedades/detalle_salud_enfermedades.routes'));
router.use('/catalogos', require('../modules/catalogos/catalogos.routes'));
router.use('/archivos', require('../modules/archivos/archivos.routes'));
router.use('/auditoria', require('../modules/auditoria/auditoria.routes'));

module.exports = router;