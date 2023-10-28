program zk_surveys.aleo {

    // Store survey ownership data privately
    record survey {
        owner: address,
        ID: u64,
    }

    // ID => number of questions
    mapping survey_questions : u64 => u8;

    // Create a survey
    transition create_survey(ID: u64, questions: u8) -> survey {
        assert(questions != 0u8);
        assert(questions < 11u8);

        // Return a new record for the survey and finalize
        return survey {
            owner: self.caller,
            ID
        } then finalize(ID, questions);
    }

    // Finalize a new survey (by ID as key) in the surveys mapping
    finalize create_survey(ID: u64, questions: u8) {
        Mapping::set(survey_questions, ID, questions);
    }

    // Voting tickets issued privately
    record ticket {
        owner: address,
        surveyID: u64,
        // questions: u8,
    }

    // surveyID => count tickets
    mapping tickets: u64 => u16;

    // Create a new ticket to vote on a survey
    transition issue_ticket(survey_record: survey, voter: address) -> (survey, ticket) {

        // Authenticate
        assert_eq(self.caller, survey_record.owner);

        // Recreate survey (consumed on input), issue ticket
        return (
            survey
            {
                owner : self.caller,
                ID : survey_record.ID,
            },
            ticket
            {
                owner: voter,
                surveyID: survey_record.ID,
                // questions: 7u8,
            }
        ) then finalize(survey_record.ID);
    }

    // Create a new ticket in the "tickets" mapping.
    finalize issue_ticket(surveyID: u64) {
        Mapping::set(tickets, surveyID, Mapping::get_or_use(tickets, surveyID, 0u16) + 1u16);
    }

    //                     |    1 - 10     |    1 - 5    |
    //| pad 48b |   u64    |      u8       |      u8     |
    //| 000...0 | surveyId | questionIndex | answerIndex | => count
    mapping answers_table : u128 => u16;

    // Uploaded by employee upon survey completion (0 = empty, 1..5 for each answer)
    struct survey_answer_data
    {
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

    // Submit a set of answers to a survey
    transition set_answer(ticket_record: ticket, data: survey_answer_data) {
        return then finalize(ticket_record.surveyID, data);
    }

    // Finalize an answer in the appropriate answers_table mapping
    finalize set_answer(surveyID : u64, data : survey_answer_data) {
        let questions : u8 = Mapping::get_or_use(survey_questions, surveyID, 0u8);

        assert(questions != 0u8);

        let rowID : u128 = ((surveyID as u128) << 16u8);

        assert(data.a1 < 6u8 && data.a1 >= 0u8);

        rowID += (256u128 + (data.a2 as u128));
        Mapping::set(answers_table, rowID, Mapping::get_or_use(answers_table, rowID, 0u16) + 1u16);

        if (questions == 2u8) {
            assert(data.a2 < 6u8 && data.a2 >= 0u8);

            rowID += (256u128 + (data.a2 as u128));
            Mapping::set(answers_table, rowID, Mapping::get_or_use(answers_table, rowID, 0u16) + 1u16);
        }

        if (questions == 3u8) {
            assert(data.a3 < 6u8 && data.a3 >= 0u8);

            rowID += (256u128 + (data.a3 as u128));
            Mapping::set(answers_table, rowID, Mapping::get_or_use(answers_table, rowID, 0u16) + 1u16);
        }

        if (questions == 4u8) {
            assert(data.a4 < 6u8 && data.a4 >= 0u8);

            rowID += (256u128 + (data.a4 as u128));
            Mapping::set(answers_table, rowID, Mapping::get_or_use(answers_table, rowID, 0u16) + 1u16);
        }

        if (questions == 5u8) {
            assert(data.a5 < 6u8 && data.a5 >= 0u8);

            rowID += (256u128 + (data.a5 as u128));
            Mapping::set(answers_table, rowID, Mapping::get_or_use(answers_table, rowID, 0u16) + 1u16);
        }

        if (questions == 6u8) {
            assert(data.a6 < 6u8 && data.a6 >= 0u8);

            rowID += (256u128 + (data.a6 as u128));
            Mapping::set(answers_table, rowID, Mapping::get_or_use(answers_table, rowID, 0u16) + 1u16);
        }

        if (questions == 7u8) {
            assert(data.a7 < 6u8 && data.a7 >= 0u8);

            rowID += (256u128 + (data.a7 as u128));
            Mapping::set(answers_table, rowID, Mapping::get_or_use(answers_table, rowID, 0u16) + 1u16);
        }

        if (questions == 8u8) {
            assert(data.a8 < 6u8 && data.a8 >= 0u8);

            rowID += (256u128 + (data.a8 as u128));
            Mapping::set(answers_table, rowID, Mapping::get_or_use(answers_table, rowID, 0u16) + 1u16);
        }

        if (questions == 9u8) {
            assert(data.a9 < 6u8 && data.a9 >= 0u8);

            rowID += (256u128 + (data.a9 as u128));
            Mapping::set(answers_table, rowID, Mapping::get_or_use(answers_table, rowID, 0u16) + 1u16);
        }

        if (questions == 10u8) {
            assert(data.a10 < 6u8 && data.a10 >= 0u8);

            rowID += (256u128 + (data.a10 as u128));
            Mapping::set(answers_table, rowID, Mapping::get_or_use(answers_table, rowID, 0u16) + 1u16);
        }
    }
}
