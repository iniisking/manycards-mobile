class GetAllSubcardReq {
  final String mainCardId;

  GetAllSubcardReq({required this.mainCardId});
}

Map<String, dynamic> getAllSubcardReqToJson(GetAllSubcardReq req) {
  return {'mainCardId': req.mainCardId};
}
