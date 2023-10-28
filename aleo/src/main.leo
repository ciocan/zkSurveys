program zk_surveys.aleo {

    // Store survey ownership data privately
    record survey {
        owner : address,
        ID : u64,
    }

    // ID => number of questions
    mapping survey_questions : u64 => u8;

    // Create a survey
    transition create_survey(ID: u64, questions: u8) -> survey {

        assert(questions != 0u8);
        assert(questions < 11u8);

        // Return a new record for the survey and finalize
        return survey {
            owner : self.caller,
            ID
        } then finalize(ID, questions);
    }

    // Finalize a new survey (by ID as key) in the surveys mapping
    finalize create_survey(ID: u64, questions: u8) {
        Mapping::set(survey_questions, ID, questions);
    }

    // Voting tickets issued privately
    record ticket {
        owner    : address,
        surveyID : u64,
    }

    // surveyID => count tickets
    mapping tickets_active: u64 => u16;

    // Create a new ticket to vote on a survey
    transition issue_ticket(survey_record: survey, voter: address) -> (survey, ticket) {

        // Authenticate
        assert_eq(self.caller, survey_record.owner);

        // Recreate survey (consumed on input), issue ticket
        return (
            survey
            {
                owner : self.caller,
                ID    : survey_record.ID,
            },
            ticket
            {
                owner    : voter,
                surveyID : survey_record.ID,
            }
        ) then finalize(survey_record.ID);
    }

    // Create a new ticket in the tickets mapping
    finalize issue_ticket(surveyID: u64) {
        Mapping::set(tickets_active, surveyID, Mapping::get_or_use(tickets_active, surveyID, 0u16) + 1u16);
    }

    //                     |    1 - 10     |    1 - 5    |
    //| pad 48b |   u64    |      u8       |      u8     |
    //| 000...0 | surveyID | questionIndex | answerIndex | => count
    mapping answers_table : u128 => u16;

    // Uploaded upon survey completion (0 = empty, 1..5 for each answer)
    struct survey_answer_data {
        a1  : u128,
        a2  : u128,
        a3  : u128,
        a4  : u128,
        a5  : u128,
        a6  : u128,
        a7  : u128,
        a8  : u128,
        a9  : u128,
        a10 : u128
    }

    // Submit a set of answers to a survey
    transition set_answer(ticket_record: ticket, data: survey_answer_data) {
        return then finalize(ticket_record.surveyID, data);
    }

    // Finalize an answer in the appropriate answers_table mapping
    finalize set_answer(surveyID : u64, data : survey_answer_data) {

        let questions : u8 = Mapping::get_or_use(survey_questions, surveyID, 0u8);

        assert(questions != 0u8);

        let rowID : u128 = ((surveyID as u128) << 16u8);

        // Survey must contain at least 1 question
        rowID += (256u128 + data.a1);
        Mapping::set(answers_table, rowID, Mapping::get_or_use(answers_table, rowID, 0u16) + 1u16);

        // Process each answer as available
        if (questions == 2u8) {
            rowID += validate_answer(data.a2);
            Mapping::set(answers_table, rowID, Mapping::get_or_use(answers_table, rowID, 0u16) + 1u16);
        }

        if (questions == 3u8) {
            rowID += validate_answer(data.a3);
            Mapping::set(answers_table, rowID, Mapping::get_or_use(answers_table, rowID, 0u16) + 1u16);
        }

        if (questions == 4u8) {
            rowID += validate_answer(data.a4);
            Mapping::set(answers_table, rowID, Mapping::get_or_use(answers_table, rowID, 0u16) + 1u16);
        }

        if (questions == 5u8) {
            rowID += validate_answer(data.a5);
            Mapping::set(answers_table, rowID, Mapping::get_or_use(answers_table, rowID, 0u16) + 1u16);
        }

        if (questions == 6u8) {
            rowID += validate_answer(data.a6);
            Mapping::set(answers_table, rowID, Mapping::get_or_use(answers_table, rowID, 0u16) + 1u16);
        }

        if (questions == 7u8) {
            rowID += validate_answer(data.a7);
            Mapping::set(answers_table, rowID, Mapping::get_or_use(answers_table, rowID, 0u16) + 1u16);
        }

        if (questions == 8u8) {
            rowID += validate_answer(data.a8);
            Mapping::set(answers_table, rowID, Mapping::get_or_use(answers_table, rowID, 0u16) + 1u16);
        }

        if (questions == 9u8) {
            rowID += validate_answer(data.a9);
            Mapping::set(answers_table, rowID, Mapping::get_or_use(answers_table, rowID, 0u16) + 1u16);
        }

        if (questions == 10u8) {
            rowID += validate_answer(data.a10);
            Mapping::set(answers_table, rowID, Mapping::get_or_use(answers_table, rowID, 0u16) + 1u16);
        }

        // Decrement active tickets counter
        Mapping::set(tickets_active, surveyID, Mapping::get_or_use(tickets_active, surveyID, 0u16) - 1u16);
    }

    inline validate_answer(answer : u128) -> u128 {
        assert(answer != 0u128 && answer < 6u128);
        return (256u128 + answer);
    }
}
