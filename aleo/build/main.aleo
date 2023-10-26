program zk_surveys.aleo;

struct Vote:
    id as u64;

struct Survey:
    id as u64;


mapping votes:
	key as u64.public;
	value as u16.public;

function main:
    input r0 as u32.public;
    input r1 as u32.private;
    add r0 r1 into r2;
    output r2 as u32.private;
