program zk_surveys.aleo {

    // Store survey ownership data privately
    record survey {
        owner: address,
        id: u64,
    }

    // id => number of questions
    mapping survey_questions : u64 => u8;

    // Create a survey
    transition create_survey(id: u64, questions: u8) -> survey {
        assert(questions != 0u8);
        assert(questions < 11u8);

        // Return a new record for the survey and finalize
        return survey {
            owner: self.caller,
            id,
        } then finalize(id, questions);
    }

    // Finalize a new survey (by id as key) in the surveys mapping
    finalize create_survey(id: u64, questions: u8) {
        Mapping::set(survey_questions, id, questions);
    }

    // Voting tickets issued privately
    record ticket {
        owner: address,
        survey_id: u64,
        // questions: u8,
    }

    // survey_id => count tickets
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
                id: survey_record.id,
            },
            ticket
            {
                owner: voter,
                survey_id: survey_record.id,
                // questions: 7u8,
            }
        ) then finalize(survey_record.id);
    }

    // Create a new ticket in the "tickets" mapping.
    finalize issue_ticket(survey_id: u64) {
        Mapping::set(tickets, survey_id, Mapping::get_or_use(tickets, survey_id, 0u16) + 1u16);
    }

    //                     |    1 - 10     |    1 - 5    |
    //| pad 48b |   u64    |      u8       |      u8     |
    //| 000...0 | surveyId | questionIndex | answerIndex | => count
    mapping answers_table : u128 => u16;

    // Uploaded by employee upon survey completion (0 = empty, 1..5 for each answer)
    struct SurveyAnswerData
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
    transition set_answer(ticket_record: ticket, data: SurveyAnswerData) {
        return then finalize(ticket_record.survey_id, data);
    }

    // Finalize an answer in the appropriate answers_table mapping
    finalize set_answer(survey_id : u64, data : SurveyAnswerData) {
        let questions : u8 = Mapping::get_or_use(survey_questions, survey_id, 0u8);

        assert(questions != 0u8);

        let row_id : u128 = ((survey_id as u128) << 16u8);

        assert(data.a1 < 6u8 && data.a1 >= 0u8);

        row_id += (256u128 + (data.a2 as u128));
        Mapping::set(answers_table, row_id, Mapping::get_or_use(answers_table, row_id, 0u16) + 1u16);

        if (questions == 2u8) {
            assert(data.a2 < 6u8 && data.a2 >= 0u8);

            row_id += (256u128 + (data.a2 as u128));
            Mapping::set(answers_table, row_id, Mapping::get_or_use(answers_table, row_id, 0u16) + 1u16);
        }

        if (questions == 3u8) {
            assert(data.a3 < 6u8 && data.a3 >= 0u8);

            row_id += (256u128 + (data.a3 as u128));
            Mapping::set(answers_table, row_id, Mapping::get_or_use(answers_table, row_id, 0u16) + 1u16);
        }

        if (questions == 4u8) {
            assert(data.a4 < 6u8 && data.a4 >= 0u8);

            row_id += (256u128 + (data.a4 as u128));
            Mapping::set(answers_table, row_id, Mapping::get_or_use(answers_table, row_id, 0u16) + 1u16);
        }

        if (questions == 5u8) {
            assert(data.a5 < 6u8 && data.a5 >= 0u8);

            row_id += (256u128 + (data.a5 as u128));
            Mapping::set(answers_table, row_id, Mapping::get_or_use(answers_table, row_id, 0u16) + 1u16);
        }

        if (questions == 6u8) {
            assert(data.a6 < 6u8 && data.a6 >= 0u8);

            row_id += (256u128 + (data.a6 as u128));
            Mapping::set(answers_table, row_id, Mapping::get_or_use(answers_table, row_id, 0u16) + 1u16);
        }

        if (questions == 7u8) {
            assert(data.a7 < 6u8 && data.a7 >= 0u8);

            row_id += (256u128 + (data.a7 as u128));
            Mapping::set(answers_table, row_id, Mapping::get_or_use(answers_table, row_id, 0u16) + 1u16);
        }

        if (questions == 8u8) {
            assert(data.a8 < 6u8 && data.a8 >= 0u8);

            row_id += (256u128 + (data.a8 as u128));
            Mapping::set(answers_table, row_id, Mapping::get_or_use(answers_table, row_id, 0u16) + 1u16);
        }

        if (questions == 9u8) {
            assert(data.a9 < 6u8 && data.a9 >= 0u8);

            row_id += (256u128 + (data.a9 as u128));
            Mapping::set(answers_table, row_id, Mapping::get_or_use(answers_table, row_id, 0u16) + 1u16);
        }

        if (questions == 10u8) {
            assert(data.a10 < 6u8 && data.a10 >= 0u8);

            row_id += (256u128 + (data.a10 as u128));
            Mapping::set(answers_table, row_id, Mapping::get_or_use(answers_table, row_id, 0u16) + 1u16);
        }
    }
}
