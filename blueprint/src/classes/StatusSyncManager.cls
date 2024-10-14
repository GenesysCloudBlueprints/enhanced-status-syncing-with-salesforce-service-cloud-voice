// ATTENTION: You will need to find the Genesys presence ids that exist in your org.

// ATTENTION: You will need to find the Salesforce status ids that exist in your org.
// Run this query in your Salesforce org to get the status ids specific to your org. You can use 15 or 18 digit ids.
// SELECT DeveloperName,Id,IsDeleted,MasterLabel FROM ServicePresenceStatus

global with sharing class TestExtension implements genesyscloud.GenesysSCVExtension.Status {
  public String onSalesforceStatusChange(String data) {
    IncomingStatusChange statusUpdate = (IncomingStatusChange) JSON.deserialize(data, IncomingStatusChange.class);
    // -----------------------------------------------------------------------------------------------------------------------------------
    // Examples of how to get current Salesforce Status Variables:
    // String salesforceCurrentStatusApiName = statusUpdate.salesforceStatus.currentStatus.statusApiName;
    // String salesforceCurrentStatusId = statusUpdate.salesforceStatus.currentStatus.statusId;
    // String salesforceCurrentStatusName = statusUpdate.salesforceStatus.currentStatus.statusName;

    // Examples of how to get target Salesforce Status Variables:
    // String salesforceTargetStatusApiName = statusUpdate.salesforceStatus.targetStatus.statusApiName;
    String salesforceTargetStatusId = statusUpdate.salesforceStatus.targetStatus.statusId;
    String salesforceTargetStatusName = statusUpdate.salesforceStatus.targetStatus.statusName;
    // -----------------------------------------------------------------------------------------------------------------------------------
    // Examples of how to get current Genesys Status Variables:
    // String genesysCurrentId = statusUpdate.genesysCloudStatus.currentStatus.id;
    // String genesysCurrentSystemPresence = statusUpdate.genesysCloudStatus.currentStatus.systemPresence;

    // Examples of how to get target Genesys Status Variables:
    String genesysTargetId = statusUpdate.genesysCloudStatus.targetStatus.id;
    // String genesysTargetSystemPresence = statusUpdate.genesysCloudStatus.targetStatus.systemPresence;
    // -----------------------------------------------------------------------------------------------------------------------------------

    // These are the variables that will be changed to update the agent's status.
    // These are default values to be sent back if no changes are made to the target statuses.
    // NOTE: If these values are NOT handled below, NO CHANGES will be made to the target statuses.
    String salesforceResponseTargetStatusId = salesforceTargetStatusId;
    String genesysResponseTargetStatusId = genesysTargetId;

    if (String.isNotEmpty(salesforceTargetStatusName)) {
      salesforceTargetStatusName = salesforceTargetStatusName.toUpperCase();
    }

    switch on salesforceTargetStatusName {
      when 'AVAILABLE FOR VOICE' {
        genesysResponseTargetStatusId = 'CHANGE ME';
      }
      when 'ONLINE' {
        genesysResponseTargetStatusId = 'CHANGE ME';
      }
      when 'NOT AVAILABLE' {
        genesysResponseTargetStatusId = 'CHANGE ME';
      }
      when null {
        // Agent clicked Offline in Omni-Channel
        genesysResponseTargetStatusId = 'CHANGE ME';
      }
      when else {
        System.debug(logginglevel.WARN, 'Salesforce status NOT HANDLED: ' + salesforceTargetStatusName);
      }
    }

    // -----------------------------------------------------------------------------------------------------------------
    // Form response object... shouldn't need to be touched.
    return JSON.serialize(new Response(genesysResponseTargetStatusId, salesforceResponseTargetStatusId));
  }

  public String onGenesysCloudStatusChange(String data) {
    IncomingStatusChange statusUpdate = (IncomingStatusChange) JSON.deserialize(data, IncomingStatusChange.class);
    // -----------------------------------------------------------------------------------------------------------------------------------
    // Examples of how to get current Salesforce Status Variables:
    // String salesforceCurrentStatusApiName = statusUpdate.salesforceStatus.currentStatus.statusApiName;
    // String salesforceCurrentStatusId = statusUpdate.salesforceStatus.currentStatus.statusId;
    // String salesforceCurrentStatusName = statusUpdate.salesforceStatus.currentStatus.statusName;

    // Examples of how to get target Salesforce Status Variables:
    // String salesforceTargetStatusApiName = statusUpdate.salesforceStatus.targetStatus.statusApiName;
    String salesforceTargetStatusId = statusUpdate.salesforceStatus.targetStatus.statusId;
    // String salesforceTargetStatusName = statusUpdate.salesforceStatus.targetStatus.statusName;
    // -----------------------------------------------------------------------------------------------------------------------------------
    // Examples of how to get current Genesys Status Variables:
    // String genesysCurrentId = statusUpdate.genesysCloudStatus.currentStatus.id;
    // String genesysCurrentSystemPresence = statusUpdate.genesysCloudStatus.currentStatus.systemPresence;

    // Examples of how to get target Genesys Status Variables:
    String genesysTargetId = statusUpdate.genesysCloudStatus.targetStatus.id;
    String genesysTargetSystemPresence = statusUpdate.genesysCloudStatus.targetStatus.systemPresence;
    // -----------------------------------------------------------------------------------------------------------------------------------

    // These are the variables that will be changed to update the agent's status.
    // These are default values to be sent back if no changes are made to the target statuses.
    // NOTE: If these values are NOT handled below, NO CHANGES will be made to the target statuses.
    String salesforceResponseTargetStatusId = salesforceTargetStatusId;
    String genesysResponseTargetStatusId = genesysTargetId;

    if (String.isNotEmpty(genesysTargetSystemPresence)) {
      genesysTargetSystemPresence = genesysTargetSystemPresence.toUpperCase();
    }

    switch on genesysTargetSystemPresence {
      when 'AVAILABLE' {
        salesforceResponseTargetStatusId = 'CHANGE ME';
      }
      when 'ON_QUEUE' {
        salesforceResponseTargetStatusId = 'CHANGE ME';
      }
      when 'AWAY' {
        salesforceResponseTargetStatusId = 'CHANGE ME';
      }
      when 'BUSY' {
        // Sets agent to Offline in Omni-Channel
        salesforceResponseTargetStatusId = '0';
      }
      when else {
        System.debug(logginglevel.WARN, 'Genesys Cloud status NOT HANDLED: ' + genesysTargetSystemPresence);
      }
    }

    // -----------------------------------------------------------------------------------------------------------------
    // Form response object... shouldn't need to be touched.
    return JSON.serialize(new Response(genesysResponseTargetStatusId, salesforceResponseTargetStatusId));
  }

  // No need to change below --------------------------------------------------------------------------------------------------------
  //#region Response Obj
  public class Response {
    public ResponseGenesysCloudStatusObj genesysCloudStatus;
    public ResponseSalesforceStatusObj salesforceStatus;
    public Response(String genesysResponseTargetStatusId, String salesforceResponseTargetStatusId) {
      this.genesysCloudStatus = new ResponseGenesysCloudStatusObj(genesysResponseTargetStatusId);
      this.salesforceStatus = new ResponseSalesforceStatusObj(salesforceResponseTargetStatusId);
    }
  }
  public class ResponseGenesysCloudStatus {
    public String id;
    public ResponseGenesysCloudStatus(String id) {
      this.id = id;
    }
  }
  public class ResponseGenesysCloudStatusObj {
    public ResponseGenesysCloudStatus targetStatus;
    public ResponseGenesysCloudStatusObj(String genesysResponseTargetStatusId) {
      this.targetStatus = new ResponseGenesysCloudStatus(genesysResponseTargetStatusId);
    }
  }
  public class ResponseSalesforceStatus {
    public String statusId;
    public ResponseSalesforceStatus(String statusId) {
      this.statusId = statusId;
    }
  }
  public class ResponseSalesforceStatusObj {
    public ResponseSalesforceStatus targetStatus;
    public ResponseSalesforceStatusObj(String salesforceResponseTargetStatusId) {
      this.targetStatus = new ResponseSalesforceStatus(salesforceResponseTargetStatusId);
    }
  }
  //#endregion Response Obj

  //#region IncomingStatusChange Obj
  public class IncomingStatusChange {
    public IncomingSalesforceStatus salesforceStatus;
    public IncomingGenesysCloudStatus genesysCloudStatus;
  }
  public class IncomingSalesforceStatusObj {
    public String statusApiName;
    public String statusId;
    public String statusName;
  }
  public class IncomingSalesforceStatus {
    public IncomingSalesforceStatusObj targetStatus;
    public IncomingSalesforceStatusObj currentStatus;
  }
  public class IncomingGenesysCloudStatusObj {
    public String id;
    public String systemPresence;
  }
  public class IncomingGenesysCloudStatus {
    public IncomingGenesysCloudStatusObj targetStatus;
    public IncomingGenesysCloudStatusObj currentStatus;
  }
  //#endregion IncomingStatusChange Obj
  // -----------------------------------------------------------------------------------------------------------------
}
