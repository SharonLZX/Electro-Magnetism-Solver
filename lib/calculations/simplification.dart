import 'package:electro_magnetism_solver/utils/helpers/simplify/extract_arithmetic.dart';
import 'package:electro_magnetism_solver/utils/helpers/simplify/extract_parents.dart';

class Simplification {
  String simplify(String function) {
    ExtractParents extractParents = ExtractParents();
    ExtractArithmetic extractArithmetic = ExtractArithmetic();

    List<int> lstIndex = [];
    List<String?> lstConst = [];
    List<String?> lstResult = [];
    List<String?> lstExtArith = [];

    bool expandPosiOne = false;
    lstExtArith = extractArithmetic.extractArithmetic(function);

    for (int i = 0; i < lstExtArith.length; i++) {
      String? function = lstExtArith[i];
      if (function == null) {
        break;
      }
      if (function.contains('(')) {
        if (i == 1) {
          expandPosiOne = true;
        }
        /*
        Since we're using i-1, if equation has a case of
        the (argument)multiplier, the code will fail (e.g 
        (5t)3, etc.).
        */

        lstResult
            .add(extractParents.extractParents(lstExtArith[i - 1], function));
      } else {
        /*
        Constants, arithmetics, and single variables (i.e. t)
        will appear here, therefore we need to sort out to store
        only relevant items ('t' & constants), excluding arithmetics.
        
        We can do this by checking if the before and after the
        index is a arithmetic.
        */
        if ((i + 1) < lstExtArith.length) {
          //If there are index infront of current i.
          if (lstExtArith[i + 1]?.contains('(') == false) {
            lstConst.add(function);
            lstIndex.add(i);
          }
        } else {
          if (function.contains('(') == false) {
            lstConst.add(function);
            lstIndex.add(i);
          }
        }
      }
    }
    /*
    PROBLEM:
    Since we have a list of the constants (lstConst), and
    the index of their ORIGINAL position (lstIndex). We should
    be able to simply use the post-expanded result (lstResult)
    and get the final result. But here's the problem, since
    the multiplier and argument has merge, we don't know what
    the NEW index is - Remember we only have the ORIGINAL 
    position of the constants.

    SOLUTION:
    So one quick workaround is that we compare the index of
    the ORIGINAL position (lstIndex) with a abitrary counter 
    (intCounter). Initially 'intCounter' will start off at 0
    and we will compare whether the index of 'lstIndex' is
    larger or smaller than. With that, we can identify whether
    it is supposed to be the 'lstResult' turn, or 'lstConst'.
    */

    /*
    PROBLEM:
    expandPosiOne is an additional workaround against the
    above problem. 
    
    Look at the equation: 5(5+5t^2)+t+t(5t),
    Notice how the middle t, is at index 2? 
    If we didn't had this check at expandPosiOne, the final
    output we'll get is 25t^0+25t^25t^2+t+ . Since, we start
    the intCounter at 0, it requires two counts to reach 2.
    Therefore, all of lstResult will be placed one after another.

    SOLUTION:
    So we can either start the intCounter at 1, OR we can
    simply minus everyone in the 'lstIndex' by 1.
    */
    if (expandPosiOne) {
      for (var i = 0; i < lstIndex.length; i++) {
        lstIndex[i] -= 1;
      }
    }

    int intCounter = 0; // Abitrary counter
    List<String?> lstFinalResult = []; // Store final results
    while (lstResult.isNotEmpty && lstConst.isNotEmpty) {
      if (lstIndex[0] > intCounter) {
        /*
        Since index is > than intCounter, that means
        that the index of result (lstResult) must come in here.
        That means that an expansion took place here.
        */
        lstFinalResult.add(lstResult[0]);
        lstResult.removeAt(0);
      } else if (lstIndex[0] == intCounter) {
        /*
        Since index is same as intCounter, we must use the
        constants from 'lstConst'.
        */
        lstFinalResult.add(lstConst[0]);
        lstConst.removeAt(0);
        lstIndex.removeAt(0);
      }
      intCounter += 1;
    }

    /*
    In the scenario where either lists is empty, and the other
    still has functions within. We can assume that the rest
    of the functions must go at the back of the 'lstFinalRes
    */
    if (lstResult.isNotEmpty) {
      for (var remaining in lstResult) {
        lstFinalResult.add(remaining);
      }
    }

    if (lstConst.isNotEmpty) {
      for (var remaining in lstConst) {
        lstFinalResult.add(remaining);
      }
    }

    return lstFinalResult.join('');
  }
}
