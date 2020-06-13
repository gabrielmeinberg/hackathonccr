import 'package:siga_saudavel_caminhoneiro/adapter/mysqlite.dart';
import 'package:siga_saudavel_caminhoneiro/main.dart';

class CartAdapter {
  var db = AppointmentDB();

  Future<int> addAppointment(Appointment appointment) async {
    return await db.insertAppointment(
        appointment.descricao, appointment.data, appointment.idProcess);
  }

  Future<List<Appointment>> getAppointment() async {
    List<Map> appointment = await db.getAppointment();

    return appointment
        .map((item) => Appointment(
            data: item['data'],
            descricao: item['descricao'],
            idProcess: item['id_process']))
        .toList();
  }
}
