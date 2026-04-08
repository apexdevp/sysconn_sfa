import 'package:sysconn_sfa/api/entity/company/party_contact_entity.dart';
import 'package:sysconn_sfa/api/entity/company/party_designation_entity.dart';

class PartyContactResponse {
  final List<PartyContactEntity> contacts;
  final List<PartyDesignationEntity> designations;

  PartyContactResponse({required this.contacts, required this.designations});
}
