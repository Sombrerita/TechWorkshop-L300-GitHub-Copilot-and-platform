
using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using ZavaStorefront.Models;
using System.Threading.Tasks;
using ZavaStorefront.Services;
using Microsoft.Extensions.Configuration;
using System.Net.Http;
using System.Text;
using System.Text.Json;

namespace ZavaStorefront.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly ProductService _productService;
        private readonly CartService _cartService;

        public HomeController(ILogger<HomeController> logger, ProductService productService, CartService cartService)
        {
            _logger = logger;
            _productService = productService;
            _cartService = cartService;
        }

        public IActionResult Index()
        {
            _logger.LogInformation("Loading products page");
            var products = _productService.GetAllProducts();
            return View(products);
        }

        [HttpPost]
        public IActionResult AddToCart(int productId)
        {
            var product = _productService.GetProductById(productId);
            if (product != null)
            {
                _logger.LogInformation("Adding product {ProductId} ({ProductName}) to cart", productId, product.Name);
                _cartService.AddToCart(productId);
            }
            else
            {
                _logger.LogWarning("Attempted to add non-existent product {ProductId} to cart", productId);
            }

            return RedirectToAction("Index");
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [HttpGet]
        public IActionResult Chat()
        {
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> Send([FromBody] ChatRequest req, [FromServices] IConfiguration config)
        {
            // Get Phi4 endpoint from configuration
            var phi4Endpoint = config["Phi4:Endpoint"];
            if (string.IsNullOrEmpty(phi4Endpoint))
                return BadRequest(new { reply = "Phi4 endpoint not configured." });

            using var http = new HttpClient();
            var payload = new { input = req.message };
            var content = new StringContent(JsonSerializer.Serialize(payload), Encoding.UTF8, "application/json");
            try
            {
                var resp = await http.PostAsync(phi4Endpoint, content);
                if (!resp.IsSuccessStatusCode)
                    return StatusCode((int)resp.StatusCode, new { reply = "Phi4 error: " + resp.ReasonPhrase });
                var json = await resp.Content.ReadAsStringAsync();
                // Assume response is { "output": "..." }
                using var doc = JsonDocument.Parse(json);
                var reply = doc.RootElement.GetProperty("output").GetString();
                return Ok(new { reply });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { reply = "Exception: " + ex.Message });
            }
        }

        public class ChatRequest
        {
            public string message { get; set; }
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}

