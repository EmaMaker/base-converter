package tk.emamaker.baseconverter;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import java.util.ArrayList;
import java.util.Arrays;

public class MainActivity extends AppCompatActivity {

    String cBase = "";
    String newBase = "";
    String num;
    String result = "";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        setupBaseSpinners();

        findViewById(R.id.editText).setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View v, boolean hasFocus) {
                if (!hasFocus) {
                    hideKeyboard(v);
                }
            }
        });
    }

    void setupBaseSpinners() {
        //Spinner for number base
        Spinner baseSpinner = (Spinner) findViewById(R.id.number_base_spinner);
        // Create an ArrayAdapter using the string array and a default spinner layout
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(this,
                R.array.nbases_array, android.R.layout.simple_spinner_item);
        // Specify the layout to use when the list of choices appears
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        // Apply the adapter to the spinner
        baseSpinner.setAdapter(adapter);

        baseSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            public void onItemSelected(AdapterView<?> parent, View view, int pos, long id) {
                cBase =  parent.getItemAtPosition(pos).toString();
            }

            public void onNothingSelected(AdapterView<?> parent) {
            }
        });

        //Spinner for conversion base
        Spinner conversionSpinner = (Spinner) findViewById(R.id.conversion_base_spinner);
        ArrayAdapter<CharSequence> adapter1 = ArrayAdapter.createFromResource(this, R.array.cbases_array, android.R.layout.simple_spinner_item);
        adapter1.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        conversionSpinner.setAdapter(adapter1);

        conversionSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            public void onItemSelected(AdapterView<?> parent, View view, int pos, long id) {
                newBase =  parent.getItemAtPosition(pos).toString();
            }

            public void onNothingSelected(AdapterView<?> parent) {
            }
        });
    }

    public void convert(View view) {

        num = ((EditText)findViewById(R.id.editText)).getText().toString();

        result = convertBase(num, cBase, newBase);

        if(!newBase.equals("Select the new number base") && !cBase.equals("Select the number base")) ((TextView)findViewById(R.id.textView)).setText(result);
        else Toast.makeText(getApplicationContext(), "Please select current number base and new one", Toast.LENGTH_SHORT);
    }

    String decimalToBase(String snum, String sbase) {

        // check if number is negative
        boolean neg = snum.startsWith("-");
        if (neg)
            snum = snum.substring(1);
        if (sbase.equals("BCD")) {
            // Binary Coded Decimal

            String result = "";

            for (char c : snum.toCharArray()) {
                String bcd = decimalToBase(String.valueOf(c), "2");
                bcd = reverseString(bcd);

                short s = (short)bcd.length();

                for (int a = 0; a < 4 - s; a++) {
                    bcd += "0";
                }
                bcd = reverseString(bcd);
                result += bcd;
            }

            if (neg) {
                result = reverseString(result);
                result += "-";
                result = reverseString(result);
            }

            return result;
        } else if (sbase.equals("CP2")) {
            // Two's Complement

            // first converts the number in binary
            String lbin = decimalToBase(snum, "2");
            lbin = reverseString(lbin);

            // appending a zero as Most Important Bit means that the number is positive. Has
            // to be done by default
            lbin += 0;
            lbin = reverseString(lbin);

            System.out.println(lbin);

            // If the number is negative it goes on with the conversion
            // starting from right, all digits stay the same until the first 1 is reached
            // after that all digits are logically negated

            if (neg) {
                String lbinneg = "";
                boolean gotOne = false;
                lbin = reverseString(lbin);

                for (char s : lbin.toCharArray()) {

                    if (!gotOne) {
                        lbinneg += s;
                        if (s == '1')
                            gotOne = true;
                    } else
                        lbinneg += 1 - (((int) s) - 48);
                }
                return lbinneg;
            }

            return lbin;

        } else {
            // Numeric Bases

            int dnum = Integer.parseInt(snum);
            ArrayList<Integer> result = new ArrayList<>();
            ArrayList<Character> cresult = new ArrayList<>();

            while (dnum != 0) {
                result.add(dnum % Integer.parseInt(sbase));
                dnum = (int) (dnum / Integer.parseInt(sbase));
            }

            for (int i : result) {
                char c;
                if (i >= 10)
                    c = (char) (i + 55);
                else
                    c = (char) (i + 48);
                cresult.add(c);
            }

            String result1 = Arrays.toString(cresult.toArray());
            if (neg)
                result1 += "-";

            result1 = result1.replace("[", "");
            result1 = result1.replace("]", "");
            result1 = result1.replace(", ", "");

            return reverseString(result1);
        }

    }

    String baseToDecimal(String snum, String sbase) {
        // check if number is negative
        boolean neg = snum.startsWith("-");
        if (neg)
            snum = snum.substring(1);

        if (sbase == "BCD") {
            // Binary Coded Decimal
            snum = reverseString(snum);
            int c = 4 - snum.length() % 4;
            for(int i = 0; i < c; i++) {
                snum += "0";
            }
            snum = reverseString(snum);

            String result = "";
            String s = "";
            for(int i = 0; i < snum.length(); i+=4) {
                s = "";
                s += snum.charAt(i + 0);
                s += snum.charAt(i + 1);
                s += snum.charAt(i + 2);
                s += snum.charAt(i + 3);

                s = reverseString(s);
                int n = Integer.parseInt(baseToDecimal(s, "2"));
//				if(n > 9) {
//		                System.err.println("Error: detected number " + s + " (" + n + ") in BCD being > 9. This is not allowed in BCD notation, please try again fixing the number");
//		                System.exit(-1);
//				}

                result += n;
            }
            return result;


        } else if (sbase == "CP2") {
            // Two's Component

            // Same as converting binary -> decimal, but the sign bit (most important bit)
            // as to be subtracted. This can be
            // done both if the number is negative (1) or positive (0). In this case, the
            // last bit will be multiplied by 0
            // and nullified

            snum = reverseString(snum);
            char[] lnum = snum.toCharArray();
            int result = 0;

            for (int i = 0; i < lnum.length; i++) {
                int p;
                if ((int) lnum[i] >= 65)
                    p = ((int) lnum[i]) - 55;
                else
                    p = ((int) lnum[i]) - 48;

                if (i == lnum.length - 1)
                    result -= (p * Math.pow(2, i));
                else
                    result += (p * Math.pow(2, i));
            }

            return String.valueOf(result);

        } else {
            char[] lnum = snum.toCharArray();
            int result = 0;

            for (int i = 0; i < lnum.length; i++) {
                int p;
                if ((int) lnum[i] >= 65)
                    p = ((int) lnum[i]) - 55;
                else
                    p = ((int) lnum[i]) - 48;

                result += (p * Math.pow(Integer.parseInt(sbase), i));
            }
            if (neg)
                result *= -1;

            return String.valueOf(result);
        }
    }

    String reverseString(String s) {
        String reversed = "";
        for (int i = 0; i < s.length(); i++) {
            reversed += s.charAt(s.length() - 1 - i);
        }
        return reversed;
    }

    String convertBase(String snum, String sbase, String snewbase) {
        boolean neg = snum.startsWith("-");
        if (neg)
            snum = snum.substring(1);
        snum += "-";
        snum = reverseString(snum);


        String s = baseToDecimal(snum, sbase);
        String s1 = decimalToBase(s, snewbase);
        return s + "("+sbase+")" + " = " + s1 + " ("+snewbase+")";
    }

    public void hideKeyboard(View view) {
        InputMethodManager inputMethodManager =(InputMethodManager)getSystemService(Activity.INPUT_METHOD_SERVICE);
        inputMethodManager.hideSoftInputFromWindow(view.getWindowToken(), 0);
    }

}
