program zk_surveys.aleo {

    struct Vote {
        id: u64,
        // answers: Vec[4],
    }

    // surveyId | questionId | answerId => count
    mapping votes: u64 => u16 ;

    struct Survey {
        id: u64,
        // questions: Vec[12],
    }

    transition main(public a: u32, b: u32) -> u32 {
        let c: u32 = a + b;
        return c;
    }
}