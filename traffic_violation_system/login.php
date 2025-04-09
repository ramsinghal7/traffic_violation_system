<?php include 'includes/db.php'; include 'includes/header.php'; ?>
<form method="POST">
  <div class="mb-3">
    <label>Username</label>
    <input type="text" name="username" class="form-control" required>
  </div>
  <div class="mb-3">
    <label>Password</label>
    <input type="password" name="password" class="form-control" required>
  </div>
  <button type="submit" class="btn btn-primary">Login</button>
</form>
<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    session_start();
    $u = $_POST['username'];
    $p = $_POST['password'];
    $sql = "SELECT * FROM users WHERE username='$u' AND password='$p'";
    $res = $conn->query($sql);
    if ($res->num_rows > 0) {
        $_SESSION['username'] = $u;
        header("Location: dashboard.php");
    } else {
        echo "<div class='alert alert-danger mt-2'>Invalid credentials</div>";
    }
}
include 'includes/footer.php'; ?>