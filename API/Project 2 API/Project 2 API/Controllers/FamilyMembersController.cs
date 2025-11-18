using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Project_2_API.Models;
using System.Linq;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace Project_2_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FamilyMembersController : ControllerBase
    {
        Project2DatabaseContext context;
        PasswordHasher<String> pHasher;

        public FamilyMembersController(Project2DatabaseContext _context)
        {
            context = _context;
            pHasher = new PasswordHasher<String>();
        }

        [HttpGet]
        [Route("getFamilyMembers")]
        public async Task<Object> GetFamilyMembers()
        {
            return Ok(await context.FamilyMembers.ToListAsync());
        }

        [HttpGet]
        [Route("getFamilyMemberById/{id}")]
        public async Task<Object> GetFamilyMemberById(int id)
        {
            var members = await context.FamilyMembers.ToListAsync();
            var member = members.Find(m => m.FamilyMemberId == id);

            if (member != null)
            {
                return Ok(member);
            }
            else
            {
                return NotFound("This family member cannot be found");
            }
        }

        [HttpPost]
        [Route("updateFamilyMember")]
        public async Task<Object> UpdateFamilyMember(FamilyMember member)
        {
            var members = await context.FamilyMembers.ToListAsync();
            var memberFound = members.Find(m => m.FamilyMemberId == member.FamilyMemberId);

            if (memberFound != null)
            {
                memberFound = member;

                context.FamilyMembers.Update(memberFound);
                await context.SaveChangesAsync();

                return Ok("Family member has been updated");
            }
            else
            {
                return NotFound("This family member cannot be found");
            }
        }

        [HttpDelete]
        [Route("deleteFamilyMember")]
        public async Task<Object> DeleteFamilyMember(int id)
        {
            var members = await context.FamilyMembers.ToListAsync();
            var memberFound = members.Find(m => m.FamilyMemberId == id);

            if (memberFound != null)
            {
                context.FamilyMembers.Remove(memberFound);
                await context.SaveChangesAsync();

                return Ok("Family member has been deleted");
            }
            else
            {
                return NotFound("This family member cannot be found");
            }
        }


        [HttpGet]
        [Route("login")]
        public async Task<Object> Login(String email, String password)
        {
            var members = await context.FamilyMembers.ToListAsync();
            var member = members.Find(m => m.FamilyMemberEmail == email);

            if (member != null)
            {
                var result = pHasher.VerifyHashedPassword(member.FamilyMemberEmail, member.FamilyMemberPassword, password);
                if (result == PasswordVerificationResult.Success)
                {
                    return Ok(member);
                }
                else
                {
                    return BadRequest("Incorrect details have been entered");
                }
            }
            else
            {
                return NotFound("This email does not exist");
            }
        }

        [HttpPost]
        [Route("signUpAsFamilyAdmin")]
        public async Task<Object> SignUpAsFamilyAdmin(FamilyMember member)
        {
            var members = await context.FamilyMembers.ToListAsync();
            var memberFound = members.Find(fm => fm.FamilyMemberEmail == member.FamilyMemberEmail);

            if (memberFound == null)
            {
                int lastIdx = 0;

                if (members.Count > 0)
                {
                    lastIdx = members.ElementAt(members.Count - 1).FamilyMemberId + 1;
                }

                member.FamilyMemberId = lastIdx;
                member.FamilyMemberPassword = pHasher.HashPassword(member.FamilyMemberEmail, member.FamilyMemberPassword);

                //Generate a groupId
                var longString = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
                var newGroupId = "";
                var random = new Random();

                for(int i = 0; i < 8; i++){
                    newGroupId += longString.ElementAt((int) random.NextInt64(longString.Length));
                }
                member.FamilyGroupId = newGroupId;

                context.FamilyMembers.Add(member);
                await context.SaveChangesAsync();

                return Ok(newGroupId);
            }
            else
            {
                return BadRequest("This email is already in use");
            }
        }
    

        [HttpPost]
        [Route("signUpInFamilyGroup")]
        public async Task<Object> SignUpInFamilyGroup(FamilyMember member, String groupId, String tempPassword)
        {
            var members = await context.FamilyMembers.ToListAsync();
            var memberfound = members.Find(m => m.FamilyMemberEmail == member.FamilyMemberEmail);

            if (memberfound != null)
            {
                if (memberfound.FamilyGroupId == groupId && memberfound.FamilyMemberPassword == tempPassword)
                {
                    memberfound.FamilyMemberName = member.FamilyMemberName;
                    memberfound.FamilyMemberSurname = member.FamilyMemberSurname;
                    memberfound.FamilyMemberPassword = pHasher.HashPassword(member.FamilyMemberEmail, member.FamilyMemberPassword);

                    context.FamilyMembers.Update(memberfound);
                    await context.SaveChangesAsync();

                    return Ok("Family member has successfully signed up");
                }
                else
                {
                    return BadRequest("The group id or temporary password are incorrect");
                }
            }
            else
            {
                return BadRequest("This email is has not been invited to any family group");
            }
        }

        [HttpPost]
        [Route("inviteMembers")]
        public async Task<Object> InviteMembers(FamilyMember member)
        {
            var members = await context.FamilyMembers.ToListAsync();
            var memberfound = members.Find(fm => fm.FamilyMemberEmail == member.FamilyMemberEmail);

            if (memberfound == null)
            {
                int lastIdx = 0;
                if (members.Count > 0)
                {
                    lastIdx = members.ElementAt(members.Count - 1).FamilyMemberId + 1;
                }

                member.FamilyMemberId = lastIdx;

                //Generate a rabdom password
                var longString = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
                var randomPassword = "";
                var random = new Random();

                for (int i = 0; i < 11; i++)
                {
                    randomPassword += longString.ElementAt((int)random.NextInt64(longString.Length));
                }
                member.FamilyMemberPassword = randomPassword;

                context.FamilyMembers.Add(member);
                await context.SaveChangesAsync();

                return Ok("Member has been added");
            }
            else
            {
                return BadRequest("Family member has already been invited");
            }
        }
    }
}
