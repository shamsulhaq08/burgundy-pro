using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace ShamsDev.BurgundyPro.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ThemeConfigController : ControllerBase
    {
        private readonly ILogger<ThemeConfigController> _logger;
        private static readonly string[] AllowedVariants = { "Burgundy Pro", "Burgundy Soft" };

        public ThemeConfigController(ILogger<ThemeConfigController> logger)
        {
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        [HttpGet("variant/{name}")]
        public async Task<ActionResult<ThemeProfile>> GetThemeProfileAsync(string name)
        {
            _logger.LogInformation("Retrieving profile for {Theme}", name);

            if (!AllowedVariants.Contains(name, StringComparer.OrdinalIgnoreCase))
            {
                return NotFound(new { Message = $"Variant '{name}' was not found." });
            }

            var profile = await Task.FromResult(new ThemeProfile
            {
                Name = name,
                BaseColor = "#160D12",
                Accent = "#702D45",
                IsPublished = true,
                CreatedAt = DateTime.UtcNow
            });

            return Ok(profile);
        }
    }

    public record ThemeProfile
    {
        public string Name { get; init; } = string.Empty;
        public string BaseColor { get; init; } = string.Empty;
        public string Accent { get; init; } = string.Empty;
        public bool IsPublished { get; init; }
        public DateTime CreatedAt { get; init; }
    }
}
