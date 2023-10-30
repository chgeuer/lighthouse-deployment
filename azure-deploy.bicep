targetScope = 'subscription'

param rgName string

var mspOfferName = 'offer'
var mspOfferDescription = 'desc'
var managedByTenantId = loadTextContent('publisher-tenant-id.txt')
var serviceProviderPrincipalId = loadTextContent('group-id.txt')
var serviceProviderPrincipalDisplayName = 'managed-app-admins'

var roles = {
  Contributor: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  UserAccessAdministrator: '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  BlobDataContributor: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
  BlobDataOwner: 'b7e6dc6d-f1e8-4753-8033-0f276bb0955b'
}

var authorizations = [
  {
    principalId: serviceProviderPrincipalId
    principalIdDisplayName: serviceProviderPrincipalDisplayName
    roleDefinitionId: roles.Contributor
  }
  {
    principalId: serviceProviderPrincipalId
    principalIdDisplayName: serviceProviderPrincipalDisplayName
    roleDefinitionId: roles.UserAccessAdministrator
    delegatedRoleDefinitionIds: [ // As a User Access Administrator, the service provider can assign these roles to managed identities on the customer side
      roles.BlobDataOwner
      roles.BlobDataContributor
    ]
  }
]

var mspRegistrationName = guid(mspOfferName)
var mspAssignmentName = guid(mspOfferName)

resource mspRegistration 'Microsoft.ManagedServices/registrationDefinitions@2019-06-01' = {
  name: mspRegistrationName
  properties: {
    registrationDefinitionName: mspOfferName
    description: mspOfferDescription
    managedByTenantId: managedByTenantId
    authorizations: authorizations
  }
}

module rgAssignment './nestedTemplates/registrationAssignment.bicep' = {
  name: 'rgAssignment'
  scope: resourceGroup(rgName)
  params: {
    mspRegistrationName: mspRegistration.id
    mspAssignmentName: mspAssignmentName
  }
}
