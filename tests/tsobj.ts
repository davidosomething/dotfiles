type Obj1 = { field: number };
type Obj2 = { field: string };
const x: Obj1 = { field: 123 };

// 2322
const y: Obj2 = x;
