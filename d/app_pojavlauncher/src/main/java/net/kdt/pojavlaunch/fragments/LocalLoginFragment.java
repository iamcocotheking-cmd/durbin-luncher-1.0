package net.kdt.pojavlaunch.fragments;

import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import net.kdt.pojavlaunch.R;
import net.kdt.pojavlaunch.Tools;
import net.kdt.pojavlaunch.extra.ExtraConstants;
import net.kdt.pojavlaunch.extra.ExtraCore;

import java.util.regex.Pattern;

public class LocalLoginFragment extends Fragment {
    public static final String TAG = "LOCAL_LOGIN_FRAGMENT";
    private static final String DEFAULT_USERNAME = "DURBIN_Player";
    private static final Pattern USERNAME_PATTERN = Pattern.compile("^[a-zA-Z0-9_]{3,16}$");

    private EditText mUsernameEditText;

    public LocalLoginFragment() {
        super(R.layout.fragment_local_login);
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        mUsernameEditText = view.findViewById(R.id.login_edit_email);
        if (mUsernameEditText.getText().toString().trim().isEmpty()) {
            mUsernameEditText.setText(DEFAULT_USERNAME);
            mUsernameEditText.setSelection(DEFAULT_USERNAME.length());
        }

        view.findViewById(R.id.login_button).setOnClickListener(v -> {
            String username = normalizeUsername(mUsernameEditText.getText().toString());
            mUsernameEditText.setText(username);

            if (!isValidUsername(username)) {
                Context context = v.getContext();
                Tools.dialog(
                        context,
                        context.getString(R.string.local_login_bad_username_title),
                        context.getString(R.string.local_login_bad_username_text)
                );
                return;
            }

            ExtraCore.setValue(ExtraConstants.MOJANG_LOGIN_TODO, new String[]{username, ""});
            Tools.swapFragment(requireActivity(), MainMenuFragment.class, MainMenuFragment.TAG, null);
        });
    }

    private static String normalizeUsername(String raw) {
        String trimmed = raw == null ? "" : raw.trim();
        return trimmed.isEmpty() ? DEFAULT_USERNAME : trimmed;
    }

    private static boolean isValidUsername(String username) {
        return USERNAME_PATTERN.matcher(username).matches();
    }
}
