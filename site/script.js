const workflowButtons = document.querySelectorAll(".workflow-item");
const commandOutput = document.querySelector("#commandOutput");

workflowButtons.forEach((button) => {
  button.addEventListener("click", () => {
    workflowButtons.forEach((item) => item.classList.remove("active"));
    button.classList.add("active");
    commandOutput.textContent = button.dataset.command;
  });
});
