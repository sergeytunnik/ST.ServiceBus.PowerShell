$testingModulePath = ($PSScriptRoot | Split-Path -Parent | Join-Path -ChildPath 'ST.ServiceBus.PowerShell')

Import-Module -Name $testingModulePath -Force

$testsConnectionString = ''
$testsNamespaceManager = [Microsoft.ServiceBus.NamespaceManager]::CreateFromConnectionString($testsConnectionString)

. ($PSScriptRoot | Join-Path -ChildPath 'Tools.ps1')

SetupTestsFixture -NamespaceManager $testsNamespaceManager


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
    it 'gets all queues' {
        $q = Get-SBQueue -NamespaceManager $testsNamespaceManager
        $q.Count | Should Be 3
    }
    
    it 'gets specific queue' {
        $q = Get-SBQueue -NamespaceManager $testsNamespaceManager -Path 'test-queue1'
        $q.Count | Should Be 1
        $q[0].Path | Should BeExactly 'test-queue1'
    }
    
    it 'can''t find specific queue' {
        { $q = Get-SBQueue -NamespaceManager $testsNamespaceManager -Path 'imnotpresent' } | Should Throw
    }
    
    it 'gets queues by filtering' {
        $q = Get-SBQueue -NamespaceManager $testsNamespaceManager -Filter 'createdAt gt ''1999-01-01'''
        $q.Count | Should BeGreaterThan 0
    }
}


Describe 'Remove-SBQueue' {
    it 'sucessfully removes queue' {
        Test-SBQueue -NamespaceManager $testsNamespaceManager -Path 'test-queue1' | Should Be $true
        Remove-SBQueue -NamespaceManager $testsNamespaceManager -Path 'test-queue1'
        Test-SBQueue -NamespaceManager $testsNamespaceManager -Path 'test-queue1' | Should Be $false
    }
}


CleanUpNamespace -NamespaceManager $testsNamespaceManager