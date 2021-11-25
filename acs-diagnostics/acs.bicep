param prefix string

resource acs 'Microsoft.Communication/communicationServices@2020-08-20' = {
  name: '${prefix}-acs'
  location: 'global'
  properties: {
    dataLocation: 'Europe'
  }
}

resource acsdiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'acsdiagnostics'
  scope: acs
  properties: {
    // Example is 'Usage' - can select Usage, AuthOperational, ChatOperational, SMSOperational, CallSummary
    logs: [
      {
        category: 'Usage'
        enabled: true
        retentionPolicy: {
          days: 31
          enabled: true
        }
      }
    ]
    metrics: [
      {
        category: 'Traffic'
        enabled: true
        retentionPolicy: {
          days: 31
          enabled: true
        }
      }
    ]
    workspaceId: logws.id
  }
  dependsOn: [
    logws
    acs
  ]
}

resource logws 'Microsoft.OperationalInsights/workspaces@2020-03-01-preview' = {
  name: '${prefix}ws'
  location: resourceGroup().location
  properties: {
    retentionInDays: 31
    sku: {
      name: 'PerGB2018'
    }
    workspaceCapping: {
      dailyQuotaGb: 2
    }
  }
}
