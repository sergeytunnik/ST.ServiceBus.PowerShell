function Get-SBNamespaceManager {
    [CmdletBinding()]
    [OutputType([Microsoft.ServiceBus.NamespaceManager])]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$ConnectionString
    )
    
    $namespaceManager = [Microsoft.ServiceBus.NamespaceManager]::CreateFromConnectionString($ConnectionString)
    
    $namespaceManager
}


function Add-SBRule {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.Messaging.SubscriptionClient]$SubscriptionClient,
        
        [Parameter(Mandatory=$true,
            ParameterSetName='RuleDescription')]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.Messaging.RuleDescription]$RuleDescription,
        
        [Parameter(Mandatory=$true,
            ParameterSetName='NameFilter')]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
        
        [Parameter(Mandatory=$true,
            ParameterSetName='NameFilter')]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.Messaging.SqlFilter]$Filter
    )
    
    switch ($PSCmdlet.ParameterSetName) {
        'RuleDescription' {
            $SubscriptionClient.AddRule($RuleDescription)
        }
        
        'NameFilter' {
            $SubscriptionClient.AddRule($Name, $Filter)
        }
    }
}


function Get-SBQueue {
    [CmdletBinding(DefaultParameterSetName='All')]
    [OutputType([Microsoft.ServiceBus.Messaging.QueueDescription[]])]
    [OutputType([Microsoft.ServiceBus.Messaging.QueueDescription], ParameterSetName='Path')]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.NamespaceManager]$NamespaceManager,
        
        [Parameter(Mandatory=$true,
            ParameterSetName='Filter')]
        [ValidateNotNullOrEmpty()]
        [string]$Filter,
    
        [Parameter(Mandatory=$true,
            ParameterSetName='Path')]
        [ValidateNotNullOrEmpty()]
        [string]$Path
    )

    switch ($PSCmdlet.ParameterSetName) {
        'All' {
            $queues = $NamespaceManager.GetQueues()
        }
        
        'Filter' {
            $queues = $NamespaceManager.GetQueues($Filter)
        }

        'Path' {
            $queues = $NamespaceManager.GetQueue($Path)
        }
    }
    
    $queues
}


function Get-SBRule {
    [CmdletBinding()]
    [OutputType([Microsoft.ServiceBus.Messaging.RuleDescription[]])]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.NamespaceManager]$NamespaceManager,
    
        [Parameter(Mandatory=$true,
            ParameterSetName='TopicPathName')]
        [Parameter(Mandatory=$true,
            ParameterSetName='TopicPathNameFilter')]
        [ValidateNotNullOrEmpty()]
        [string]$TopicPath,
        
        [Parameter(Mandatory=$true,
            ParameterSetName='TopicPathName')]
        [Parameter(Mandatory=$true,
            ParameterSetName='TopicPathNameFilter')]
        [ValidateNotNullOrEmpty()]
        [string]$SubscriptionName,
        
        [Parameter(Mandatory=$true,
            ParameterSetName='TopicPathNameFilter')]
        [ValidateNotNullOrEmpty()]
        [string]$Filter
    )
    
    switch ($PSCmdlet.ParameterSetName) {
        'TopicPathName' {
            $rules = $NamespaceManager.GetRules($TopicPath, $SubscriptionName)
        }
        
        'TopicPathNameFilter' {
            $rules = $NamespaceManager.GetRules($TopicPath, $SubscriptionName, $Filter)
        }
    }

    $rules
}


function Get-SBSubscription {
    [CmdletBinding(DefaultParameterSetName='TopicPath')]
    [OutputType([Microsoft.ServiceBus.Messaging.SubscriptionDescription[]])]
    [OutputType([Microsoft.ServiceBus.Messaging.SubscriptionDescription], ParameterSetName='Name')]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.NamespaceManager]$NamespaceManager,

        [Parameter(Mandatory=$true,
            ParameterSetName='Filter')]
        [Parameter(Mandatory=$true,
            ParameterSetName='Name')]
        [Parameter(Mandatory=$true,
            ParameterSetName='TopicPath')]
        [ValidateNotNullOrEmpty()]
        [string]$TopicPath,
    
        [Parameter(Mandatory=$false,
            ParameterSetName='Name')]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
        
        [Parameter(Mandatory=$false,
            ParameterSetName='Filter')]
        [ValidateNotNullOrEmpty()]
        [string]$Filter
    )
    
    switch ($PSCmdlet.ParameterSetName) {
        'Filter' {
            $subscriptions = $NamespaceManager.GetSubscriptions($TopicPath, $Filter)
        }
        
        'Name' {
            $subscriptions = $NamespaceManager.GetSubscription($TopicPath, $Name)
        }
        
        'TopicPath' {
            $subscriptions = $NamespaceManager.GetSubscriptions($TopicPath)
        }
    }
    
    $subscriptions
}


function Get-SBSubscriptionClient {
    [CmdletBinding()]
    [OutputType([Microsoft.ServiceBus.Messaging.SubscriptionClient])]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$ConnectionString,
        
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$TopicPath,
        
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )
    
    $subscriptionClient = [Microsoft.ServiceBus.Messaging.SubscriptionClient]::CreateFromConnectionString($ConnectionString, $TopicPath, $Name)
    
    $subscriptionClient
}


function Get-SBTopic {
    [CmdletBinding(DefaultParameterSetName='All')]
    [OutputType([Microsoft.ServiceBus.Messaging.TopicDescription[]])]
    [OutputType([Microsoft.ServiceBus.Messaging.TopicDescription], ParameterSetName='Path')]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.NamespaceManager]$NamespaceManager,
        
        [Parameter(Mandatory=$true,
            ParameterSetName='Filter')]
        [ValidateNotNullOrEmpty()]
        [string]$Filter,
    
        [Parameter(Mandatory=$true,
            ParameterSetName='Path')]
        [ValidateNotNullOrEmpty()]
        [string]$Path
    )

    switch ($PSCmdlet.ParameterSetName) {
        'All' {
            $topics = $NamespaceManager.GetTopics()
        }
        
        'Filter' {
            $topics = $NamespaceManager.GetTopics($Filter)
        }

        'Path' {
            $topics = $NamespaceManager.GetTopic($Path)
        }
    }
    
    $topics
}


function New-SBQueue {
    [CmdletBinding()]
    [OutputType([Microsoft.ServiceBus.Messaging.QueueDescription])]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.NamespaceManager]$NamespaceManager,
        
        [Parameter(Mandatory=$true,
            ParameterSetName='Path')]
        [ValidateNotNullOrEmpty()]
        [string]$Path,
        
        [Parameter(Mandatory=$true,
            ParameterSetName='Description')]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.Messaging.QueueDescription]$QueueDescription
    )
    
    switch ($PSCmdlet.ParameterSetName) {
        'Path' {
            $queue = $NamespaceManager.CreateQueue($Path)
        }
        
        'Description' {
            $queue = $NamespaceManager.CreateQueue($QueueDescription)
        }
    }
    
    $queue
}


function New-SBQueueDescription {
    [CmdletBinding(DefaultParameterSetName='Path')]
    [OutputType([Microsoft.ServiceBus.Messaging.QueueDescription])]
    Param(
        [Parameter(Mandatory=$true,
            ParameterSetName='Path')]
        [Parameter(Mandatory=$true,
            ParameterSetName='PathProperties')]
        [ValidateNotNullOrEmpty()]
        [string]$Path,
        
        [Parameter(Mandatory=$true,
            ParameterSetName='PathProperties')]
        [Parameter(Mandatory=$true,
            ParameterSetName='Properties')]
        [ValidateNotNull()]
        [hashtable]$Properties
    )
    
    $validProperties = @('AutoDeleteOnIdle',
        'DefaultMessageTimeToLive',
        'DuplicateDetectionHistoryTimeWindow',
        'EnableBatchedOperations',
        'EnableDeadLetteringOnMessageExpiration',
        'EnableExpress',
        'EnablePartitioning',
        #'ExtensionData',
        'ForwardDeadLetteredMessagesTo',
        'ForwardTo',
        'IsAnonymousAccessible',
        'LockDuration',
        'MaxDeliveryCount',
        'MaxSizeInMegabytes',
        'Path',
        'RequiresDuplicateDetection',
        'RequiresSession',
        'Status',
        'SupportOrdering',
        'UserMetadata')
    
    switch ($PSCmdlet.ParameterSetName) {
        'Path' {
            $queueDescription = New-Object -TypeName 'Microsoft.ServiceBus.Messaging.QueueDescription' -ArgumentList $Path
        }
        
        'PathProperties' {
            $queueDescription = New-Object -TypeName 'Microsoft.ServiceBus.Messaging.QueueDescription' -ArgumentList $Path
            
            foreach ($key in $Properties.Keys) {
                if ($validProperties -contains $key) {
                    $queueDescription.$key = $Properties[$key]
                } else {
                    Write-Warning -Message "$key isn't valid QueueDescription property. Skipping."
                }
            }
        }
        
        'Properties' {
            $queueDescription = New-Object -TypeName 'Microsoft.ServiceBus.Messaging.QueueDescription' -ArgumentList $Properties['Path']
            
            foreach ($key in $Properties.Keys) {
                if ($validProperties -contains $key) {
                    $queueDescription.$key = $Properties[$key]
                } else {
                    Write-Warning -Message "$key isn't valid QueueDescription property. Skipping."
                }
            }
        }
    }
    
    $queueDescription
}


function New-SBRuleDescription {
    [CmdletBinding(DefaultParameterSetName='DefaultValues')]
    [OutputType([Microsoft.ServiceBus.Messaging.RuleDescription])]
    Param(
        [Parameter(Mandatory=$true,
            ParameterSetName='Name')]
        [Parameter(Mandatory=$true,
            ParameterSetName='NameFilter')]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
        
        [Parameter(Mandatory=$true,
            ParameterSetName='Filter')]
        [Parameter(Mandatory=$true,
            ParameterSetName='NameFilter')]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.Messaging.SqlFilter]$Filter,
        
        [Parameter(Mandatory=$false)]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.Messaging.SqlRuleAction]$RuleAction
    )
    
    switch ($PSCmdlet.ParameterSetName) {
        'DefaultValues' {
            $ruleDescription = New-Object -TypeName 'Microsoft.ServiceBus.Messaging.RuleDescription'
        }
        
        'Filter' {
            $ruleDescription = New-Object -TypeName 'Microsoft.ServiceBus.Messaging.RuleDescription' -ArgumentList $Filter
        }
        
        'Name' {
            $ruleDescription = New-Object -TypeName 'Microsoft.ServiceBus.Messaging.RuleDescription' -ArgumentList $Name
        }
        
        'NameFilter' {
            $ruleDescription = New-Object -TypeName 'Microsoft.ServiceBus.Messaging.RuleDescription' -ArgumentList @($Name, $Filter)
        }
    }
    
    if ($PSBoundParameters.ContainsKey('RuleAction')) {
        $ruleDescription.Action = $RuleAction
    }
    
    $ruleDescription
}


function New-SBSubscription {
    [CmdletBinding()]
    [OutputType([Microsoft.ServiceBus.Messaging.SubscriptionDescription])]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.NamespaceManager]$NamespaceManager,

        [Parameter(Mandatory=$true,
            ParameterSetName='TopicPathName')]
        [Parameter(Mandatory=$true,
            ParameterSetName='TopicPathNameFilter')]
        [Parameter(Mandatory=$true,
            ParameterSetName='TopicPathNameRuleDescription')]
        [ValidateNotNullOrEmpty()]
        [string]$TopicPath,
    
        [Parameter(Mandatory=$true,
            ParameterSetName='TopicPathName')]
        [Parameter(Mandatory=$true,
            ParameterSetName='TopicPathNameFilter')]
        [Parameter(Mandatory=$true,
            ParameterSetName='TopicPathNameRuleDescription')]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
        
        [Parameter(Mandatory=$true,
            ParameterSetName='SubscriptionDescription')]
        [Parameter(Mandatory=$true,
            ParameterSetName='SubscriptionDescriptionFilter')]
        [Parameter(Mandatory=$true,
            ParameterSetName='SubscriptionDescriptionRuleDescription')]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.Messaging.SubscriptionDescription]$SubscriptionDescription,
        
        [Parameter(Mandatory=$true,
            ParameterSetName='TopicPathNameFilter')]
        [Parameter(Mandatory=$true,
            ParameterSetName='SubscriptionDescriptionFilter')]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.Messaging.SqlFilter]$Filter,
        
        [Parameter(Mandatory=$true,
            ParameterSetName='TopicPathNameRuleDescription')]
        [Parameter(Mandatory=$true,
            ParameterSetName='SubscriptionDescriptionRuleDescription')]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.Messaging.RuleDescription]$RuleDescription
    )
    
    switch ($PSCmdlet.ParameterSetName) {
        'SubscriptionDescription' {
            $subscription = $NamespaceManager.CreateSubscription($SubscriptionDescription)
        }
        
        'SubscriptionDescriptionFilter' {
            $subscription = $NamespaceManager.CreateSubscription($SubscriptionDescription, $Filter)
        }
        
        'SubscriptionDescriptionRuleDescription' {
            $subscription = $NamespaceManager.CreateSubscription($SubscriptionDescription, $RuleDescription)
        }
        
        'TopicPathName' {
            $subscription = $NamespaceManager.CreateSubscription($TopicPath, $Name)
        }
        
        'TopicPathNameFilter' {
            $subscription = $NamespaceManager.CreateSubscription($TopicPath, $Name, $Filter)
        }
        
        'TopicPathNameRuleDescription' {
            $subscription = $NamespaceManager.CreateSubscription($TopicPath, $Name, $RuleDescription)
        }
    }
    
    $subscription
}


function New-SBTopic {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.NamespaceManager]$NamespaceManager,
        
        [Parameter(Mandatory=$true,
            ParameterSetName='Path')]
        [ValidateNotNullOrEmpty()]
        [string]$Path,
        
        [Parameter(Mandatory=$true,
            ParameterSetName='Description')]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.Messaging.TopicDescription]$TopicDescription
    )
    
    switch ($PSCmdlet.ParameterSetName) {
        'Path' {
            $topic = $NamespaceManager.CreateTopic($Path)
        }
        
        'Description' {
            $topic = $NamespaceManager.CreateTopic($TopicDescription)
        }
    }
    
    $topic
}


function Remove-SBQueue {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.NamespaceManager]$NamespaceManager,
        
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path
    )
    
    $NamespaceManager.DeleteQueue($Path)
}


function Remove-SBRule {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.Messaging.SubscriptionClient]$SubscriptionClient,
        
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )
    
    $SubscriptionClient.RemoveRule($Name)
}


function Remove-SBSubscription {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.NamespaceManager]$NamespaceManager,
        
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$TopicPath,
        
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )
    
    $NamespaceManager.DeleteSubscription($TopicPath, $Name)
}


function Remove-SBTopic {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.NamespaceManager]$NamespaceManager,
        
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path
    )
    
    $NamespaceManager.DeleteTopic($Path)
}


function Test-SBQueue {
    [CmdletBinding()]
    [OutputType([bool])]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.NamespaceManager]$NamespaceManager,
        
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path
    )
    
    $NamespaceManager.QueueExists($Path)
}


function Test-SBSubscription {
    [CmdletBinding()]
    [OutputType([bool])]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.NamespaceManager]$NamespaceManager,
        
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$TopicPath,
        
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )
    
    $NamespaceManager.SubscriptionExists($TopicPath, $Name)
}


function Test-SBTopic {
    [CmdletBinding()]
    [OutputType([bool])]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.NamespaceManager]$NamespaceManager,
        
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path
    )
    
    $NamespaceManager.TopicExists($Path)
}


function Update-SBQueue {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.NamespaceManager]$NamespaceManager,
        
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Description')]
        [Microsoft.ServiceBus.Messaging.QueueDescription]$QueueDescription
    )
    
    $NamespaceManager.UpdateQueue($QueueDescription)
}


function Update-SBSubscription {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.NamespaceManager]$NamespaceManager,
        
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Description')]
        [Microsoft.ServiceBus.Messaging.SubscriptionDescription]$SubscriptionDescription
    )
    
    $NamespaceManager.UpdateSubscription($SubscriptionDescription)
}


function Update-SBQueue {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.NamespaceManager]$NamespaceManager,
        
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Description')]
        [Microsoft.ServiceBus.Messaging.QueueDescription]$QueueDescription
    )
    
    $NamespaceManager.UpdateQueue($QueueDescription)
}


function Update-SBSubscription {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.NamespaceManager]$NamespaceManager,
        
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Description')]
        [Microsoft.ServiceBus.Messaging.SubscriptionDescription]$SubscriptionDescription
    )
    
    $NamespaceManager.UpdateSubscription($SubscriptionDescription)
}


function Update-SBTopic {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.NamespaceManager]$NamespaceManager,
        
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Description')]
        [Microsoft.ServiceBus.Messaging.TopicDescription]$TopicDescription
    )
    
    $NamespaceManager.UpdateTopic($TopicDescription)
}
