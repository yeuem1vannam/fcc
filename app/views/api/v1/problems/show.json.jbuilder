json.success 1
json.result @res.present?
json.point @res.try :received_point
