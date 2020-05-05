/**
 * @description Clase para la demostración de Apex Replay Debug, contiene un ejercicio práctico.
 *              Para ejecutar el método es posible ejecutarlo desde la clase ApexReplayDebugguerTest
 *              El método es el llamado: automaticApprovalTest().
 */
public with sharing class ApexReplayDebugguer
{
    public ApexReplayDebugguer(){}

    /**
     * @description Aprobación automática del proceso de aprobación.
     *              ¿Quien es el aprobador final, cual es su alias?
     *              ¿Que comentario ha incluído?
     *              ¿En que ronda se ha aprobado el registro? ** Cada iteración del bucle se considera una ronda, empieza por el 1.
     */
    public static void automaticApproval()
    {
        Integer round = 1;
        List<String> comments = new List<String>
        {
            'Lo apruebo gustosamente!',
            '¿Que es esto?',
            'Aceptado por lástima',
            'Si claro ...',
            'あなたはとても好奇心が強い',
            '01100101011011100110001101110010011010010111000001110100011000010110010001101111',
            '<script>salesforceInjection()<script>',
            'comentario de relleno'
        };
        // Los usuarios que realizarán la aprobación.
        List<User> users = [SELECT id, 
                                   Alias,
                                   Name,
                                   UserName
                            FROM USER 
                            WHERE (Profile.Name = 'Administrador del sistema' OR Profile.Name = 'System Administrator')
                            AND UserName LIKE '%ApexReplayDebugguerUser%'
                            ORDER BY Alias DESC];
        // El proceso de aprobación pendiente.
        List<ProcessInstanceWorkitem> pcsWItem = [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.ProcessDefinition.DeveloperName = 'ApexReplayDebugguerApproval'];
        // Se genera un nuevo request de tipo Approve
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setWorkitemId(pcsWItem[0].Id);

        // Se asigna un aprobador y un comentario
        while (round < users.size())
        {
            req.setComments(comments[round]);
            req.setNextApproverIds(new Id[] {users[round].Id});
            if (round == users.size() - round)
            {
                round = 0;
                break;
            }
            // Se pasa a la siguiente ronda de asignaciones
            round++;
        }
        
        // Se procesan los registros
        req.setAction('Approve');
        Approval.process(req);
    }
}