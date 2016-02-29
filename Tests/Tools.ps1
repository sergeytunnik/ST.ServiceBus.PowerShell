function CleanUpNamespace {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.NamespaceManager]$NamespaceManager
    )
    
    $topics = Get-SBTopic -NamespaceManager $NamespaceManager
    
    foreach ($topic in $topics) {
        Remove-SBTopic -NamespaceManager $NamespaceManager -Path ($topic.Path)
    }
    
    $queues = Get-SBQueue -NamespaceManager $NamespaceManager
    
    foreach ($queue in $queues) {
        Remove-SBQueue -NamespaceManager $NamespaceManager -Path ($queue.Path)
    }
}


function SetupTestsFixture {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [Microsoft.ServiceBus.NamespaceManager]$NamespaceManager
    )
    
    $topics = @('test-topic1', 'test-topic2', 'test-topic3')
    $queues = @('test-queue1', 'test-queue2', 'test-queue3')
    $subscriptions = @('test-subscr1', 'test-subscr2', 'test-subscr3')
    
    foreach ($topic in $topics) {
        $td = New-SBTopic -NamespaceManager $NamespaceManager -Path $topic
        
        foreach ($subscription in $subscriptions) {
            $sd = New-SBSubscription -NamespaceManager $NamespaceManager -TopicPath ($td.Path) -Name $subscription
        }
    }
    
    foreach ($queue in $queues) {
        $qd = New-SBQueue -NamespaceManager $NamespaceManager -Path $queue
    }
}