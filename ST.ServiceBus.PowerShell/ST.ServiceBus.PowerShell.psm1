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
            $qd = New-Object -TypeName Microsoft.ServiceBus.Messaging.QueueDescription -ArgumentList $Path
            $qd2 = $NamespaceManager.CreateQueue($qd)
        }
        
        'Description' {
            $qd2 = $NamespaceManager.CreateQueue($QueueDescription)
        }
    }
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
        [ValidateNotNullOrEmpty()]
        [string]$Filter,
        
        [Parameter(Mandatory=$true,
            ParameterSetName='TopicPathNameRuleDescription')]
        [Parameter(Mandatory=$true,
            ParameterSetName='SubscriptionDescriptionRuleDescription')]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.Messaging.RuleDescription]$RuleDescription
    )
    
    switch ($PSCmdlet.ParameterSetName) {
        'SubscriptionDescription' {
            $subscriptions = $NamespaceManager.CreateSubscriptions($SubscriptionDescription)
        }
        
        'SubscriptionDescriptionFilter' {
            $subscriptions = $NamespaceManager.CreateSubscriptions($SubscriptionDescription, $Filter)
        }
        
        'SubscriptionDescriptionRuleDescription' {
            $subscriptions = $NamespaceManager.CreateSubscriptions($SubscriptionDescription, $RuleDescription)
        }
        
        'TopicPathName' {
            $subscriptions = $NamespaceManager.CreateSubscription($TopicPath, $Name)
        }
        
        'TopicPathNameFilter' {
            $subscriptions = $NamespaceManager.CreateSubscription($TopicPath, $Name, $Filter)
        }
        
        'TopicPathNameRuleDescription' {
            $subscriptions = $NamespaceManager.CreateSubscription($TopicPath, $Name, $RuleDescription)
        }
    }
    
    $subscriptions
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
            $qd = New-Object -TypeName Microsoft.ServiceBus.Messaging.TopicDescription -ArgumentList $Path
            $qd2 = $NamespaceManager.CreateTopic($qd)
        }
        
        'Description' {
            $qd2 = $NamespaceManager.CreateQueue($TopicDescription)
        }
    }
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
