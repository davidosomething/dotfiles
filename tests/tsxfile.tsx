import * as React from 'react';
export default [ 'nothing' ];

interface Deep {
  first: {
    second: {
      str: string
      int: number
    }
  }
}

const a: Deep = {
  first: {
    third: {
      fail: null
    }
  }
}

const b: Deep = {}

console.log(a)

const RED = 'red';
const BURGUNDY = 'rgba(255, 101, 120, 0.5)';

const arr = [ 1, 2, 3, 4 ];

const expression = () => {};

export function abc() {
  return (
    <div style="color: red;">
      {expression()}
      <Fragment>
        {`hi ${there}`}
      </Fragment>
      <>
        <Another>
          <Test
            prop1="abc"
            prop2={{ def: GHI.JKL }}
            poop={false}
            //commentedProp={true}
          >Strings in strings in strings
          </Test>
        </Another>
      </>
    </div>
  );
};
