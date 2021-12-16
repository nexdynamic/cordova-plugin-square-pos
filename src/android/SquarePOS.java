package SquarePOS;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONException;
import android.content.Context;
import android.widget.Toast;
import com.squareup.sdk.pos.PosClient;
import com.squareup.sdk.pos.PosSdk;
import com.squareup.sdk.pos.ChargeRequest;
import com.squareup.sdk.pos.CurrencyCode;

public class SquarePOS extends CordovaPlugin {
	@Override
	public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
		if ("echo".equals(action)) {
			echo(args.getObject(0), args.get, callbackContext);
			return true;
		}

		return false;
	}

	void initTransaction(JSONObject params, CallbackContext callbackContext) {
        Number amount = params.getNumber("amount");
        String currencyCode = params.getString("currencyCode");
        String squareApplicationId = params.getString("squareApplicationId");
        String squareCallbackURL = params.getString("squareCallbackURL");
        String notes = params.getString("notes");

        PosClient posClient = PosSdk.createClient(this, squareApplicationId);
        ChargeRequest request = new ChargeRequest.Builder(amount, currencyCode).build();
        try {
            Intent intent = posClient.createChargeIntent(request);
            startActivityForResult(intent, 1);
        } catch (ActivityNotFoundException e) {
            AlertDialogHelper.showDialog(
                this,
                "Error",
                "Square Point of Sale is not installed"
                );
            posClient.openPointOfSalePlayStoreListing();
      }

		if (msg == null || msg.length() == 0) {
			callbackContext.error("Empty message!");
		} else {
			Toast.makeText(webView.getContext(), msg, Toast.LENGTH_LONG).show();
			callbackContext.success(msg);
		}
	}
}

   