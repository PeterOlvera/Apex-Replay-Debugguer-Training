@isTest
public with sharing class ApexReplayDebugguerTest
{
    /**
     * @Description Ejecuta la prueba de esta demo.
     */
    @isTest
    public static void automaticApprovalTest()
    {
        Test.startTest();
        ApexReplayDebugguer.automaticApproval();
        Test.stopTest();
    }
    
    /**
     * @description Se genera el entorno para el test.
     */
    @TestSetup
    public static void createData()
    {
        // Se insertan los usuarios de prueba
        List<User> usersToTest = creteUsers();
        insert usersToTest;
        // Se inserta la cuenta a evaluar.
        Account accountToTest = new Account(Name = 'ApexReplayDebugguerAccount');
        insert accountToTest;
        // Se inicia el proceso de aprobación.
        createApprovalProcess('ApexReplayDebugguerApproval', usersToTest[0].Id, new List<Id>{usersToTest[N_USERS_TO_CREATE-5].Id}, accountToTest.Id, '¿es correcto el test?');
    }

    /**
     * @description Se crean los usuarios para esta prueba.
     */
    public static List<User> creteUsers()
    {
        List<User> usersToInsert = new List<User>();
        Profile pf = [SELECT id FROM Profile WHERE Name = 'Administrador del sistema' OR Name = 'System Administrator' LIMIT 1];
        List<String> names = new List<String>{'Lucas Valenzuela', 'Jason Pace', 'Cruz Mccoy', 'Harrison Black', 'Alan Hansen', 'Len Preston', 'Hammett Solis', 'Carter Riley'};
        
        for (Integer i = 0; i < N_USERS_TO_CREATE; i++)
        {
            usersToInsert.add(
                new User(
                    FirstName        = names[N_USERS_TO_CREATE-(i+1)].split(' ')[0],
                    LastName         = names[N_USERS_TO_CREATE-(i+1)].split(' ')[1],
                    ProfileId        = pf.Id,
                    UserName         = names[N_USERS_TO_CREATE-(i+1)].replace(' ','') + '@ApexReplayDebugguerUser.com',
                    Email            = names[N_USERS_TO_CREATE-(i+1)].replace(' ','') + '@ApexReplayDebugguerUser.com',
                    Alias            = names[N_USERS_TO_CREATE-(i+1)].replace(' ','').left(8),
                    TimeZoneSidKey   = 'Europe/Paris',
                    LocaleSidKey     = 'es_ES',
                    EmailEncodingKey = 'ISO-8859-1',
                    LanguageLocaleKey= 'es'
                )
            );
        }

        return usersToInsert;
    }

    /**
     * @description Se genera el proceso de aprobación para la demo.
     */
    public static void createApprovalProcess(String approvalProcessName, Id senderId, List<Id> approversId, Id evaluatedRecordId, String comment)
    {
        Approval.ProcessSubmitRequest approvalProcess = new Approval.ProcessSubmitRequest();
        //Establece las propiedades del proceso de aprobación.
        approvalProcess.setComments(comment);
        approvalProcess.setObjectId(evaluatedRecordId);
        approvalProcess.setSubmitterId(senderId);
        approvalProcess.setNextApproverIds(approversId);     
        //Selecciona el proceso de aprobación.
        approvalProcess.setProcessDefinitionNameOrId(approvalProcessName);
        //Inicia el proceso
        Approval.process(approvalProcess);
    }

    static Integer N_USERS_TO_CREATE = 8;
}