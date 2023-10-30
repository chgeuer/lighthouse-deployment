
param mspRegistrationName string

param mspAssignmentName string

resource variables_mspAssignment 'Microsoft.ManagedServices/registrationAssignments@2019-06-01' = {
  name: mspAssignmentName
  properties: {
    registrationDefinitionId: mspRegistrationName
  }
}
