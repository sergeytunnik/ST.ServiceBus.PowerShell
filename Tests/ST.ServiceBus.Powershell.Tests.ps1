$testingModulePath = ($PSScriptRoot | Split-Path -Parent | Join-Path -ChildPath 'ST.ServiceBus.PowerShell')

Import-Module -Name $testingModulePath -Force

$testsConnectionString = ''
$testsNamespaceManager = [Microsoft.ServiceBus.NamespaceManager]::CreateFromConnectionString($testsConnectionString)

. ($PSScriptRoot | Join-Path -ChildPath 'Tools.ps1')

SetupTestsFixture -NamespaceManager $testsNamespaceManager


Describe 'Add-SBRule' {
    It 'successfully adds rule using name and filter' {
        $sc = Get-SBSubscriptionClient -ConnectionString $testsConnectionString -TopicPath 'test-topic1' -Name 'test-subscr1'
        Add-SBRule -SubscriptionClient $sc -Name 'test-rule1' -Filter 'Priority > 42'
        $allrules = Get-SBRule -NamespaceManager $testsNamespaceManager -TopicPath 'test-topic1' -SubscriptionName 'test-subscr1'
        $exactrule = $allrules | Where-Object -FilterScript { $_.Name -eq 'test-rule1' }
        $exactrule | Should BeOfType [Microsoft.ServiceBus.Messaging.RuleDescription]
        $exactrule.Filter.SqlExpression | Should BeExactly 'Priority > 42'
    }
    
    It 'successfully adds rule using RuleDescription with action' {
        $sc = Get-SBSubscriptionClient -ConnectionString $testsConnectionString -TopicPath 'test-topic1' -Name 'test-subscr1'
        $rd = New-SBRuleDescription -Name 'test-rule2' -Filter 'Size < 12' -RuleAction 'Set TextSize = "S"'
        Add-SBRule -SubscriptionClient $sc -RuleDescription $rd
        $allrules = Get-SBRule -NamespaceManager $testsNamespaceManager -TopicPath 'test-topic1' -SubscriptionName 'test-subscr1'
        $exactrule = $allrules | Where-Object -FilterScript { $_.Name -eq 'test-rule2' }
        $exactrule | Should BeOfType [Microsoft.ServiceBus.Messaging.RuleDescription]
        $exactrule.Filter.SqlExpression | Should BeExactly 'Size < 12'
        $exactrule.Action.SqlExpression | Should BeExactly 'Set TextSize = "S"'
    }
    
    It 'throws when adding rule duplicated name' {
        $sc = Get-SBSubscriptionClient -ConnectionString $testsConnectionString -TopicPath 'test-topic1' -Name 'test-subscr1'
        { Add-SBRule -SubscriptionClient $sc -Name 'test-rule1' -Filter 'Priority > 42' } | Should Throw
    }
}

 Describe 'Get-SBNamespaceManager' {
     It 'throws on bad connection string' {
         { Get-SBNamespaceManager -ConnectionString 'Bad;connection;string' } | Should Throw
     }
     
     It 'returns proper NamespaceManager object' {
         $nm = Get-SBNamespaceManager -ConnectionString $testsConnectionString
         $nm | Should BeOfType [Microsoft.ServiceBus.NamespaceManager] 
     }
 }
 
 
 Describe 'Get-SBSubscriptionClient' {
     It 'throws on bad connection string' {
         { Get-SBSubscriptionClient -ConnectionString 'Bad;connection;string' `
         -TopicPath 'test-topic' -Name 'test-subscr' } | Should Throw
     }
     
     It 'returns proper SubscriptionClient object' {
         $sc = Get-SBSubscriptionClient -ConnectionString $testsConnectionString -TopicPath 'test-topic1' -Name 'test-subscr1'
         $sc | Should BeOfType [Microsoft.ServiceBus.Messaging.SubscriptionClient] 
     } 
 }

 
Describe 'Get-SBQueue' {
    It 'gets all queues' {
        $q = Get-SBQueue -NamespaceManager $testsNamespaceManager
        $q.Count | Should Be 3
    }
    
    It 'gets specific queue' {
        $q = Get-SBQueue -NamespaceManager $testsNamespaceManager -Path 'test-queue1'
        $q.Count | Should Be 1
        $q[0].Path | Should BeExactly 'test-queue1'
    }
    
    It 'can''t find specific queue' {
        { $q = Get-SBQueue -NamespaceManager $testsNamespaceManager -Path 'imnotpresent' } | Should Throw
    }
    
    It 'gets queues by filtering' {
        $q = Get-SBQueue -NamespaceManager $testsNamespaceManager -Filter 'createdAt gt ''1999-01-01'''
        $q.Count | Should BeGreaterThan 0
    }
}


Describe 'Remove-SBQueue' {
    It 'successfully removes queue' {
        Test-SBQueue -NamespaceManager $testsNamespaceManager -Path 'test-queue1' | Should Be $true
        Remove-SBQueue -NamespaceManager $testsNamespaceManager -Path 'test-queue1'
        Test-SBQueue -NamespaceManager $testsNamespaceManager -Path 'test-queue1' | Should Be $false
    }
}


Describe 'Remove-SBRule' {
    It 'successfully removes rule' {
        $allrules = Get-SBRule -NamespaceManager $testsNamespaceManager -TopicPath 'test-topic1' -SubscriptionName 'test-subscr1'
        $exactrule = $allrules | Where-Object -FilterScript { $_.Name -eq 'test-rule1' }
        $exactrule | Should Not BeNullOrEmpty
        
        $sc = Get-SBSubscriptionClient -ConnectionString $testsConnectionString -TopicPath 'test-topic1' -Name 'test-subscr1'
        Remove-SBRule -SubscriptionClient $sc -Name 'test-rule1'
        
        $allrules = Get-SBRule -NamespaceManager $testsNamespaceManager -TopicPath 'test-topic1' -SubscriptionName 'test-subscr1'
        $exactrule = $allrules | Where-Object -FilterScript { $_.Name -eq 'test-rule1' }
        $exactrule | Should BeNullOrEmpty
    } 
}


Describe 'Remove-SBSubscription' {
    It 'successfully removes subscription' {
        Test-SBSubscription -NamespaceManager $testsNamespaceManager -TopicPath 'test-topic3' -Name 'test-subscr3' | Should Be $true
        Remove-SBSubscription -NamespaceManager $testsNamespaceManager -TopicPath 'test-topic3' -Name 'test-subscr3'
        Test-SBSubscription -NamespaceManager $testsNamespaceManager -TopicPath 'test-topic3' -Name 'test-subscr3' | Should Be $false
    }
}


Describe 'Remove-SBTopic' {
    It 'successfully removes topic' {
        Test-SBTopic -NamespaceManager $testsNamespaceManager -Path 'test-topic3' | Should Be $true
        Remove-SBTopic -NamespaceManager $testsNamespaceManager -Path 'test-topic3'
        Test-SBTopic -NamespaceManager $testsNamespaceManager -Path 'test-topic3' | Should Be $false
    }
}


Describe 'Test-SBQueue' {
    It 'gets positive check' {
        Test-SBQueue -NamespaceManager $testsNamespaceManager -Path 'test-queue3' | Should Be $true
    }
    
    It 'gets negative check' {
        Test-SBQueue -NamespaceManager $testsNamespaceManager -Path 'nonexistqueue' | Should Be $false
    }
}


Describe 'Test-SBSubscription' {
    It 'gets positive check' {
        Test-SBSubscription -NamespaceManager $testsNamespaceManager -TopicPath 'test-topic2' -Name 'test-subscr2' | Should Be $true
    }
    
    It 'gets negative check' {
        Test-SBSubscription -NamespaceManager $testsNamespaceManager -TopicPath 'nonexisttopic' -Name 'nonexistsubscr' | Should Be $false
    }
}


Describe 'Test-SBTopic' {
    It 'gets positive check' {
        Test-SBTopic -NamespaceManager $testsNamespaceManager -Path 'test-topic2' | Should Be $true
    }
    
    It 'gets negative check' {
        Test-SBTopic -NamespaceManager $testsNamespaceManager -Path 'nonexisttopic' | Should Be $false
    }
}


CleanUpNamespace -NamespaceManager $testsNamespaceManager