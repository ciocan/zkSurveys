program zk_surveys.aleo {

    // Survey object container
    struct SurveyData {
        proposer: address,  // account
        title: field,       // text -> how do we set this as string from the frontend ui?
        expires: u64        // timestamp -> how do we check this timestamp against local date on chain? oracol date?
                            // use blocknumber?
        q1: field,
        q2: field,
        q3: field,
        q4: field,
        q5: field,
        q6: field,
        q7: field,
        q8: field,
        q9: field,
        q10: field,
    }

    // surveyID => data
    mapping Surveys: field => SurveyData

    // Survey record to store survey data privately
    record Survey {
        owner: address,
        ID: field,
        data: SurveyData
    }

    // Create a survey
    transition CreateSurvey(public info: SurveyData) -> Survey {

        // Authenticate
        assert_eq(self.caller, info.proposer);

        // Generate survey ID
        let ID: field = BHP256::hash_to_field(info.title);

        // Return a new record for the survey and finalize
        return Survey {
            owner: self.caller,
            ID,
            info,
        } then finalize(ID);
    }

    // Finalize a new survey (key) in the Tickets mapping
    finalize CreateSurvey(public ID: field) {
        Mapping::set(Tickets, ID, 0u64);
    }

    struct Question {
        ID: field,          // GUID
        proposer: address,  // account
        content: field      // text
    }

    // Voting tickets issued privately
    record Ticket {
        owner: address,
        surveyID: field
    }

    // struct Answer {
    //     questionID: field,
    //     rating: u8,
    //     ticket: Ticket
    // }

    // Uploaded by employee upon survey completion (0 = empty, 1..5 for each answer)
    struct EmployeeAnswerData
    {
        surveyID : field,
        a1: u8,
        a2: u8,
        a3: u8,
        a4: u8,
        a5: u8,
        a6: u8,
        a7: u8,
        a8: u8,
        a9: u8,
        a10: u8
    }

    // Holds a row with counts of answers of each type for a question (A = 1 ... E = 5)
    struct AnswerRow
    {
        A : u64,
        B : u64,
        C : u64,
        D : u64,
        E : u64
    }

    // Holds a matrix of all answer counts for each question
    struct AnswerTable
    {
        q1: AnswerRow,
        q2: AnswerRow,
        q3: AnswerRow,
        q4: AnswerRow,
        q5: AnswerRow,
        q6: AnswerRow,
        q7: AnswerRow,
        q8: AnswerRow,
        q9: AnswerRow,
        q10: AnswerRow
    }

    // surveyID => counts
    mapping Answers: field => AnswerTable

    // mapping surveyID: field => AnswerData

    // // Count the total tickets issued for each survey
    // // surveyID => ticket count
    // mapping Tickets: field => u64;

    // // 0000 | surveyId | questionId | answerId => count
    // mapping votes: u64 => u16;

    // // Add question to a survey
    // transition AddQuestion(public survey: SurveyData) -> Survey {
    //     // Authenticate
    //     assert_eq(self.caller, survey.proposer);

    //     // Generate survey ID
    //     let ID: field = BHP256::hash_to_field(info.title);

    //     // Return a new record for the survey and finalize
    //     return Survey {
    //         owner: self.caller,
    //         ID,
    //         info,
    //     } then finalize(ID);
    // }

    // // Finalize a new survey (key) in the Tickets mapping
    // finalize AddQuestion(public ID: field) {
    //     Mapping::set(Tickets, ID, 0u64);
    // }

    // TODO: How to authorize this -- query for surveyID and check the owner???
    // Create a new ticket to vote on a survey
    transition IssueTicket(public surveyID: field, public voter: address) -> Ticket {

        // Authenticate
        assert_eq(self.caller, surveyID.owner);

        // Finalize ticket
        return Ticket {
            surveyID,
            owner: voter,
        };// then finalize(surveyID);
    }

    // // Finalize a new ticket on a survey in the Tickets mapping
    // finalize IssueTicket(public surveyID: field) {
    //     let current: u64 = Mapping::get_or_use(Tickets, surveyID, 0u64);
    //     Mapping::set(Tickets, surveyID, current + 1u64);
    // }

    // Submit an answer to a question
    transition Answer(public data: EmployeeAnswerData) {
        assert(data.a1 < 6 && data.a1 >= 0);
        assert(data.a2 < 6 && data.a2 >= 0);
        assert(data.a3 < 6 && data.a3 >= 0);
        assert(data.a4 < 6 && data.a4 >= 0);
        assert(data.a5 < 6 && data.a5 >= 0);
        assert(data.a6 < 6 && data.a6 >= 0);
        assert(data.a7 < 6 && data.a7 >= 0);
        assert(data.a8 < 6 && data.a8 >= 0);
        assert(data.a9 < 6 && data.a9 >= 0);
        assert(data.a10 < 6 && data.a10 >= 0);

        return then finalize(data);
    }

    // Finalize an answer in the appropriate Answer mapping
    finalize Answer(public data: EmployeeAnswerData) {
        let table = Mapping::get(Answers, data.surveyID);

        table.q1

        {
            if      (rating == 1) { table.q1.A += 1; }
            else if (rating == 2) { table.q1.B += 1; }
            else if (rating == 3) { table.q1.C += 1; }
            else if (rating == 4) { table.q1.D += 1; }
            else if (rating == 5) { table.q1.E += 1; }
        }

        // if      (rating == 1) { Mapping::set(AnswerA, questionID, Mapping::get_or_use(AnswerA, questionID, 0u64) + 1); }
        // else if (rating == 2) { Mapping::set(AnswerB, questionID, Mapping::get_or_use(AnswerB, questionID, 0u64) + 1); }
        // else if (rating == 3) { Mapping::set(AnswerC, questionID, Mapping::get_or_use(AnswerC, questionID, 0u64) + 1); }
        // else if (rating == 4) { Mapping::set(AnswerD, questionID, Mapping::get_or_use(AnswerD, questionID, 0u64) + 1); }
        // else if (rating == 5) { Mapping::set(AnswerE, questionID, Mapping::get_or_use(AnswerE, questionID, 0u64) + 1); }
    }

    transition main(public a: u32, b: u32) -> u32 {
        let c: u32 = a + b;
        return c;
    }
}
