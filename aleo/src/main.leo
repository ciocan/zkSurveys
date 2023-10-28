program zk_surveys.aleo {

    // Store survey ownership data privately
    record survey {
        owner : address,
        id    : u64,
    }

    // id => number of questions
    mapping survey_questions : u64 => u8;

    // Create a survey
    transition create_survey(id: u64, questions: u8) -> survey {

        assert(questions != 0u8);
        assert(questions < 11u8);

        // Return a new record for the survey and finalize
        return survey {
            owner : self.caller,
            id
        } then finalize(id, questions);
    }

    // Finalize a new survey (by id as key) in the surveys mapping
    finalize create_survey(id: u64, questions: u8) {
        Mapping::set(survey_questions, id, questions);
    }

    // Voting tickets issued privately
    record ticket {
        owner     : address,
        survey_id : u64,
    }

    // survey_id => count tickets
    mapping tickets_active : u64 => u16;

    // Create a new ticket to vote on a survey
    transition issue_ticket(survey_record: survey, voter: address) -> (survey, ticket) {

        // Authenticate
        assert_eq(self.caller, survey_record.owner);

        // Recreate survey (consumed on input), issue ticket
        return (
            survey
            {
                owner : self.caller,
                id    : survey_record.id,
            },
            ticket
            {
                owner     : voter,
                survey_id : survey_record.id,
            }
        ) then finalize(survey_record.id);
    }

    // Create a new ticket in the tickets mapping
    finalize issue_ticket(survey_id: u64) {
        Mapping::set(tickets_active, survey_id, Mapping::get_or_use(tickets_active, survey_id, 0u16) + 1u16);
    }

    //                      |    1 - 10     |    1 - 5    |
    //| pad 48b |   u64     |      u8       |      u8     |
    //| 000...0 | survey_id | questionIndex | answerIndex | => count
    mapping answers_table : u128 => u16;

    // Uploaded upon survey completion (0 = empty, 1..5 for each answer)
    struct SurveyAnswerData {
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
    transition set_answer(ticket_record: ticket, data: SurveyAnswerData) {
        return then finalize(ticket_record.survey_id, data);
    }

    // Finalize an answer in the appropriate answers_table mapping
    finalize set_answer(survey_id : u64, data : SurveyAnswerData) {

        let questions : u8 = Mapping::get_or_use(survey_questions, survey_id, 0u8);

        assert(questions != 0u8);

        let row_id : u128 = ((survey_id as u128) << 16u8);

        // Survey must contain at least 1 question
        row_id += (256u128 + data.a1);
        Mapping::set(answers_table, row_id, Mapping::get_or_use(answers_table, row_id, 0u16) + 1u16);

        // Process each answer as available
        if (questions == 2u8) {
            row_id += validate_answer(data.a2);
            Mapping::set(answers_table, row_id, Mapping::get_or_use(answers_table, row_id, 0u16) + 1u16);
        }

        if (questions == 3u8) {
            row_id += validate_answer(data.a3);
            Mapping::set(answers_table, row_id, Mapping::get_or_use(answers_table, row_id, 0u16) + 1u16);
        }

        if (questions == 4u8) {
            row_id += validate_answer(data.a4);
            Mapping::set(answers_table, row_id, Mapping::get_or_use(answers_table, row_id, 0u16) + 1u16);
        }

        if (questions == 5u8) {
            row_id += validate_answer(data.a5);
            Mapping::set(answers_table, row_id, Mapping::get_or_use(answers_table, row_id, 0u16) + 1u16);
        }

        if (questions == 6u8) {
            row_id += validate_answer(data.a6);
            Mapping::set(answers_table, row_id, Mapping::get_or_use(answers_table, row_id, 0u16) + 1u16);
        }

        if (questions == 7u8) {
            row_id += validate_answer(data.a7);
            Mapping::set(answers_table, row_id, Mapping::get_or_use(answers_table, row_id, 0u16) + 1u16);
        }

        if (questions == 8u8) {
            row_id += validate_answer(data.a8);
            Mapping::set(answers_table, row_id, Mapping::get_or_use(answers_table, row_id, 0u16) + 1u16);
        }

        if (questions == 9u8) {
            row_id += validate_answer(data.a9);
            Mapping::set(answers_table, row_id, Mapping::get_or_use(answers_table, row_id, 0u16) + 1u16);
        }

        if (questions == 10u8) {
            row_id += validate_answer(data.a10);
            Mapping::set(answers_table, row_id, Mapping::get_or_use(answers_table, row_id, 0u16) + 1u16);
        }

        // Decrement active tickets counter
        Mapping::set(tickets_active, survey_id, Mapping::get_or_use(tickets_active, survey_id, 0u16) - 1u16);
    }

    inline validate_answer(answer : u128) -> u128 {
        assert(answer != 0u128 && answer < 6u128);
        return (256u128 + answer);
    }
}
