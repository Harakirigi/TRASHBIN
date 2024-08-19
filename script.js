const demo = document.getElementById("demo");

function big() {
	demo.style.fontSize="50px"
};
function small() {
	demo.style.fontSize="20px"
};

document.getElementsByName("color").forEach(radio => {
	radio.addEventListener("click", () => {
		demo.style.color=radio.value
	})
})



demo.innerHTML = "bruh";
demo.innerHTML = "My First JavaScript";
demo.style.color = "lightgreen";
demo.style.fontSize = "30px";
