# Union Shop (Flutter)

This is a small Flutter sample app used for coursework and demonstrations.

## LCOV Coverage workflow

A GitHub Actions workflow at `.github/workflows/lcov-report.yml` runs tests and posts an HTML coverage report as a PR comment using `romeovs/lcov-reporter-action`.

How it works

- The workflow runs on pushes to `main` and `CW`, and on pull requests.
- It checks out the repository, sets up Flutter, runs `flutter pub get`, then runs `flutter test --coverage` to produce `coverage/lcov.info`.
- The workflow uploads `coverage/lcov.info` as an artifact (optional) and then calls `romeovs/lcov-reporter-action` to post a coverage HTML comment to the pull request.

Customizing the workflow

- Change which branches trigger the workflow by editing `.github/workflows/lcov-report.yml`.
- To only post coverage for PRs, remove or restrict the `push` event and keep `pull_request`.
- To provide a different lcov file path, change the `lcov-file` input (defaults to `./coverage/lcov.info`).
- If you run tests in a separate job, remove the test step from the reporter job and instead pass the `lcov.info` artifact to the reporter job. Use job-level `needs:` and `actions/upload-artifact` / `actions/download-artifact` to pass artifacts between jobs.

Secrets and tokens

- The workflow uses the default `GITHUB_TOKEN` to post comments. If you want to use a personal access token with broader permissions, create a repository secret and set `GITHUB_TOKEN: ${{ secrets.YOUR_TOKEN_NAME }}` in the workflow step environment.

Troubleshooting

- If the reporter fails to find `coverage/lcov.info`, ensure your tests ran with coverage and that the file exists.
- For Flutter web or platform tests, ensure `flutter test --coverage` is appropriate for your test targets.
- If comments don't appear on PRs, verify the workflow ran on the PR and `GITHUB_TOKEN` has permissions (default token works for normal repo comments).

Example: minimal reporter-only job

If you already run tests elsewhere, you can replace the `Run tests with coverage` step with artifact download and then call the reporter only. See the workflow file for more details.
