public class FBLeadIntegration {
public static String accessToken = 'EAAQr6gkM54oBO41KJPpZCODgRsBthbWx3VqwgX2FGDCFgQhZAdnzGilE8MtIcnh1xvpRKmHY2JkzuVsNsiUbYaiBjWCFP60ZBZCHyaPtZAhvKl1I6ZBRxqlBccyc8XJHu1i0aYiCOir6YVk4sxqrBmsxJ6uIOx3tZCZCqwXN5lz7yQQ4NB6teItwqHiPTFyDWkAYZAXHGuKFqZBUk1ZCbjQ4gQZD';
    public static String formId = '1332657601385389';

 
    public class FacebookLead {
        public String id;
        public String created_time;
        public List<FieldData> field_data;
    }
 
    public class FieldData {
        public String name;
        public List<String> values;
    }
 
    public class FBLeadResponse {
        public List<FacebookLead> data;
    }
 
    @future(callout=true)
    public static void fetchLeads() {
        try {
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://graph.facebook.com/v18.0/' + formId + '/leads?access_token=' + accessToken);
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
 
            HttpResponse res = http.send(req);
 
            if(res.getStatusCode() == 200) {
                FBLeadResponse fbResponse = (FBLeadResponse) JSON.deserialize(res.getBody(), FBLeadResponse.class);
 
                for(FacebookLead lead : fbResponse.data) {
                    String email = '';
                    String fullName = '';
                    String phone = '';
                    String city = '';
                    String company = '';
                    String State = '' ;
                    String Country = '' ;
                    String JobTitle = '' ;
                    
 
                    for(FieldData field : lead.field_data) {
                        if (field.values != null && !field.values.isEmpty()) {
                            if(field.name == 'email') {
                                email = field.values[0];
                            } else if(field.name == 'full_name' || field.name == 'name') {
                                fullName = field.values[0];
                            } else if(field.name == 'phone_number') {
                                phone = field.values[0];
                            } else if(field.name == 'city') {
                                city = field.values[0];
                            } else if(field.name == 'company_name') {
                                company = field.values[0];
                            }
                            else if(field.name == 'state') {
                                State = field.values[0];
                            }
                            else if(field.name == 'country') {
                                Country = field.values[0];
                            }
                            else if(field.name == 'job_title') {
                                JobTitle = field.values[0];
                            }
                        }
                    }
 
                    Lead newLead = new Lead();
                    newLead.LastName = (fullName != '') ? fullName : 'Facebook Lead';
                    newLead.Email = email;
                    newLead.Phone = phone;
                    newLead.City = city;
                    newLead.Company = (company != '') ? company : 'Facebook Lead Ads';
                    newLead.LeadSource = 'Facebook Lead Ads';
                    newLead.Description = Country;
                    //newLead.Job Title = 'Facebook Lead Ads';
                    //newLead.LeadSource = 'Facebook Lead Ads';
 
                    try {
                        insert newLead;
                        System.debug('Lead inserted successfully: ' + newLead.Id);
                    } catch(DmlException e) {
                        System.debug('Error inserting lead: ' + e.getMessage());
                    }
                }
            } else {
                System.debug('Error in Facebook API: ' + res.getBody());
            }
 
        } catch(Exception e) {
            System.debug('Exception: ' + e.getMessage());
        }
    }
}