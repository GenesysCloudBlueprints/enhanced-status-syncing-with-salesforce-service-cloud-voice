global with sharing class StatusSyncManager implements genesyscloud.GenesysSCVExtension.Status {
  // ATTENTION: You will need to find the Salesforce status ids and the Genesys Cloud status ids that exist in your orgs.

  public class GenesysCloudStatus {
    public GenesysTargetStatus targetStatus;
    public GenesysCloudStatus(GenesysTargetStatus targetStatus) {
      this.targetStatus = targetStatus;
    }
  }
  public class GenesysTargetStatus {
    public String id;
    public GenesysTargetStatus(String id) {
      this.id = id;
    }
  }
  public class SalesforceStatus {
    public SalesforceTargetStatus targetStatus;
    public SalesforceStatus(SalesforceTargetStatus targetStatus) {
      this.targetStatus = targetStatus;
    }
  }
  public class SalesforceTargetStatus {
    public String statusId;
    public SalesforceTargetStatus(String statusId) {
      this.statusId = statusId;
    }
  }
  public class Response {
    public GenesysCloudStatus genesysCloudStatus;
    public SalesforceStatus salesforceStatus;
    public Response(GenesysCloudStatus genesysCloudStatus, SalesforceStatus salesforceStatus) {
      this.genesysCloudStatus = genesysCloudStatus;
      this.salesforceStatus = salesforceStatus;
    }
  }

  // ATTENTION: Run this API call in your Genesys Cloud org to get the status ids specific to your org.
  // API Enpoint: https://api.{region}.com/api/v2/systempresences
  public String onSalesforceStatusChange(String data) {
    Map<String, Object> statusData = (Map<String, Object>) JSON.deserializeUntyped(data);
    Map<String, Object> salesforceStatusMap = (Map<String, Object>) statusData.get('salesforceStatus');
    Map<String, Object> salesforceInputStatus = (Map<String, Object>) salesforceStatusMap.get('targetStatus');
    Map<String, Object> genesysStatusMap = (Map<String, Object>) statusData.get('genesysCloudStatus');
    Map<String, Object> genesysInputStatus = (Map<String, Object>) genesysStatusMap.get('targetStatus');
    String statusName = '';
    String statusId = '';
    String id = '';
    String presence = '';
    if (salesforceInputStatus != null) {
      statusName = (String) salesforceInputStatus.get('statusName');
      statusId = (String) salesforceInputStatus.get('statusId');
    }
    if (genesysInputStatus != null) {
      id = (String) genesysInputStatus.get('id');
      presence = (String) genesysInputStatus.get('systemPresence');
    }
    GenesysTargetStatus genesysTargetStatus = new GenesysTargetStatus(id);
    SalesforceTargetStatus salesforceTargetStatus = new SalesforceTargetStatus(statusId);
    GenesysCloudStatus genesysCloudStatus = new GenesysCloudStatus(genesysTargetStatus);
    SalesforceStatus salesforceStatus = new SalesforceStatus(salesforceTargetStatus);

    if (String.isNotEmpty(statusName)) {
      statusName = statusName.toUpperCase();
    }
    switch on statusName {
      when 'AVAILABLE FOR VOICE' {
        genesysTargetStatus = new GenesysTargetStatus('CHANGE ME');
      }
      when 'ONLINE' {
        genesysTargetStatus = new GenesysTargetStatus('CHANGE ME');
      }
      when 'NOT AVAILABLE' {
        genesysTargetStatus = new GenesysTargetStatus('CHANGE ME');
      }
      when else {
        System.debug('Salesforce status not found or is null: ' + statusName);
      }
    }
    genesysCloudStatus = new GenesysCloudStatus(genesysTargetStatus);
    salesforceStatus = new SalesforceStatus(salesforceTargetStatus);
    Response response = new Response(genesysCloudStatus, salesforceStatus);
    return JSON.serialize(response);
  }

  // ATTENTION: Run this query in your Salesforce org to get the status ids specific to your org. You can use 15 or 18 digit ids.
  // SELECT DeveloperName, Id, MasterLabel FROM ServicePresenceStatus WHERE IsDeleted = false
  public String onGenesysCloudStatusChange(String data) {
    Map<String, Object> statusData = (Map<String, Object>) JSON.deserializeUntyped(data);
    Map<String, Object> salesforceStatusMap = (Map<String, Object>) statusData.get('salesforceStatus');
    Map<String, Object> salesforceInputStatus = (Map<String, Object>) salesforceStatusMap.get('targetStatus');
    Map<String, Object> genesysStatusMap = (Map<String, Object>) statusData.get('genesysCloudStatus');
    Map<String, Object> genesysInputStatus = (Map<String, Object>) genesysStatusMap.get('targetStatus');
    String statusName = '';
    String statusId = '';
    String id = '';
    String presence = '';
    if (salesforceInputStatus != null) {
      statusName = (String) salesforceInputStatus.get('statusName');
      statusId = (String) salesforceInputStatus.get('statusId');
    }
    if (genesysInputStatus != null) {
      id = (String) genesysInputStatus.get('id');
      presence = (String) genesysInputStatus.get('systemPresence');
    }
    GenesysTargetStatus genesysTargetStatus = new GenesysTargetStatus(id);
    SalesforceTargetStatus salesforceTargetStatus = new SalesforceTargetStatus(statusId);
    GenesysCloudStatus genesysCloudStatus = new GenesysCloudStatus(genesysTargetStatus);
    SalesforceStatus salesforceStatus = new SalesforceStatus(salesforceTargetStatus);

    if (String.isNotBlank(presence)) {
      presence = presence.toUpperCase();
    }
    switch on presence {
      when 'AVAILABLE' {
        salesforceTargetStatus = new SalesforceTargetStatus('CHANGE ME');
      }
      when 'ON_QUEUE' {
        salesforceTargetStatus = new SalesforceTargetStatus('CHANGE ME');
      }
      when 'AWAY' {
        salesforceTargetStatus = new SalesforceTargetStatus('CHANGE ME');
      }
      when else {
        System.debug('Genesys Cloud status not found or is null: ' + statusName);
      }
    }
    genesysCloudStatus = new GenesysCloudStatus(genesysTargetStatus);
    salesforceStatus = new SalesforceStatus(salesforceTargetStatus);
    Response response = new Response(genesysCloudStatus, salesforceStatus);
    return JSON.serialize(response);
  }
}
