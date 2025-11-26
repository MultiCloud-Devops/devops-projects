<script>
function handleSubmit(e){
  e.preventDefault();
  const st = document.getElementById("formStatus");
  st.textContent = "Sending...";
  setTimeout(()=> st.textContent = "Message sent!", 800);
}

console.log("Bright SaaS landing loaded");
</script>